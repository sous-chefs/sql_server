#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: sql_server
# Recipe:: server
#
# Copyright:: 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

service_name = node['sql_server']['instance_name']
if node['sql_server']['instance_name'] == 'SQLEXPRESS'
  service_name = "MSSQL$#{node['sql_server']['instance_name']}"
end

static_tcp_reg_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\\' + node['sql_server']['reg_version'] +
  node['sql_server']['instance_name'] + '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'

# generate and set a password for the 'sa' super user
node.set_unless['sql_server']['server_sa_password'] = "#{secure_password}-aA12"
# force a save so we don't lose our generated password on a failed chef run
node.save unless Chef::Config[:solo]

config_file_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], "ConfigurationFile.ini"))

template config_file_path do
  source "ConfigurationFile.ini.erb"
end

if /PrepareImage/i.match(node['sql_server']['setup_action']) || /CompleteImage/i.match(node['sql_server']['setup_action'])
  #execute "SQL Server SysPrep #{node['sql_server']['setup_action']}" do
  #  command "start \"\" /wait \"#{node['sql_server']['server']['url']}\" /q /ConfigurationFile=\"#{config_file_path}\""
  #end
  sql_install_wrapper_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], "SQL#{node['sql_server']['version']}_install_wrapper.bat"))
  template sql_install_wrapper_path do
    source "sql_install_wrapper.bat.erb"
    variables(
      config_file_path: config_file_path,
      sql_setup_url: node['sql_server']['server']['url']
    )
  end

  windows_task "Create SQL Server SysPrep #{node['sql_server']['setup_action']} Scheduled Task" do
    user node['sql_server']['setup_task']['user'] if node['sql_server']['setup_task']['user']
    password node['sql_server']['setup_task']['password'] if node['sql_server']['setup_task']['password']
    name "SQL Server SysPrep #{node['sql_server']['setup_action']}"
    command "start '' /wait #{sql_install_wrapper_path}"
    #command "'#{node['sql_server']['server']['url']}' /q /ConfigurationFile='#{config_file_path}'"
    #run_level :highest
    action [ :create, :change, :run ]
    frequency :monthly
    frequency_modifier 12
  end

  windows_task "Delete SQL Server SysPrep #{node['sql_server']['setup_action']} Scheduled Task" do
    user node['sql_server']['setup_task']['user'] if node['sql_server']['setup_task']['user']
    password node['sql_server']['setup_task']['password'] if node['sql_server']['setup_task']['password']
    name "SQL Server SysPrep #{node['sql_server']['setup_action']}"
    action [ :delete ]
  end
else
  windows_package node['sql_server']['server']['package_name'] do
    source node['sql_server']['server']['url']
    checksum node['sql_server']['server']['checksum']
    timeout node['sql_server']['server']['installer_timeout']
    installer_type :custom
    options "/q /ConfigurationFile=#{config_file_path}"
    action :install
  end
end


if ( /Install/i.match(node['sql_server']['setup_action']) || /CompleteImage/i.match(node['sql_server']['setup_action']) ) &&
  ( /SQL/i.match(node['sql_server']['feature_list']) || /ALLFeatures_WithDefaults/i.match(node['sql_server']['install_role']) )
  service service_name do
    action :nothing
  end

  # set the static tcp port
  registry_key static_tcp_reg_key do
    values [{ :name => 'TcpPort', :type => :string, :data => node['sql_server']['port'].to_s },
            { :name => 'TcpDynamicPorts', :type => :string, :data => '' }]
    notifies :restart, "service[#{service_name}]", :immediately
  end
end
include_recipe 'sql_server::client'
