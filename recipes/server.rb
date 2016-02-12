#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: sql_server
# Recipe:: server
#
# Copyright:: 2011-2016, Chef Software, Inc.
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

Chef::Application.fatal!("node['sql_server']['server_sa_password'] must be set for this cookbook to run") if node['sql_server']['server_sa_password'].nil?

service_name = if node['sql_server']['instance_name'] == 'SQLEXPRESS'
                 "MSSQL$#{node['sql_server']['instance_name']}"
               else
                 node['sql_server']['instance_name']
               end

# Compute registry version based on sql server version
reg_version = node['sql_server']['reg_version'] ||
              case node['sql_server']['version']
              when '2008' then 'MSSQL10.'
              when '2008R2' then 'MSSQL10_50.'
              when '2012' then 'MSSQL11.'
              when '2014' then 'MSSQL12.'
              when '2016' then 'MSSQL13.'
              else raise "Unsupported sql_server version '#{node['sql_server']['version']}'"
              end

static_tcp_reg_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\\' + reg_version +
                     node['sql_server']['instance_name'] + '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'

config_file_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], 'ConfigurationFile.ini'))

sql_sys_admin_list = if node['sql_server']['sysadmins'].is_a? Array
                       node['sql_server']['sysadmins'].map { |account| %("#{account}") }.join(' ') # surround each in quotes, space delimit list
                     else
                       %("#{node['sql_server']['sysadmins']}") # surround in quotes
                     end

template config_file_path do
  source 'ConfigurationFile.ini.erb'
  variables(
    sqlSysAdminList: sql_sys_admin_list
  )
end

version = node['sql_server']['version']
x86_64 = node['kernel']['machine'] =~ /x86_64/

package_url = node['sql_server']['server']['url'] ||
              SqlServer::Helper.sql_server_url(version, x86_64) ||
              Chef::Application.fatal!("No package URL matches '#{version}'. node['sql_server']['server']['url'] must be set or node['sql_server']['version'] must match a supported version.")

package_name = node['sql_server']['server']['package_name'] ||
               SqlServer::Helper.sql_server_package_name(version, x86_64) ||
               Chef::Application.fatal!("No package name matches '#{version}'. node['sql_server']['server']['package_name'] must be set or node['sql_server']['version'] must match a supported version.")

package_checksum = node['sql_server']['server']['checksum'] ||
                   SqlServer::Helper.sql_server_checksum(version, x86_64) ||
                   Chef::Application.fatal!("No package checksum matches '#{version}'. node['sql_server']['server']['checksum'] must be set or node['sql_server']['version'] must match a supported version.")

# Build safe password command line options for the installer
# see http://technet.microsoft.com/library/ms144259
passwords_options = {
  AGTSVCPASSWORD: node['sql_server']['agent_account_pwd'],
  RSSVCPASSWORD:  node['sql_server']['rs_account_pwd'],
  SQLSVCPASSWORD: node['sql_server']['sql_account_pwd']
}.map do |option, attribute|
  next unless attribute
  # Escape password double quotes and backslashes
  safe_password = attribute.gsub(/["\\]/, '\\\\\0')
  "/#{option}=\"#{safe_password}\""
end.compact.join ' '

windows_package package_name do
  source package_url
  checksum package_checksum
  timeout node['sql_server']['server']['installer_timeout']
  installer_type :custom
  options "/q /ConfigurationFile=#{config_file_path} #{passwords_options}"
  action :install
end

# set the static tcp port
registry_key static_tcp_reg_key do
  values [{ name: 'TcpPort', type: :string, data: node['sql_server']['port'].to_s },
          { name: 'TcpDynamicPorts', type: :string, data: '' }]
  recursive true
  notifies :restart, "service[#{service_name}]", :immediately
end

service service_name do
  action [:start, :enable]
end

include_recipe 'sql_server::client'
