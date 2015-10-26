#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: sql_server
# Recipe:: server
#
# Copyright:: 2011, Chef Software, Inc.
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
::Chef::Recipe.send(:include, Windows::Helper)

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

config_file_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], 'ConfigurationFile.ini'))

if node['sql_server']['sysadmins'].is_a? Array
  sql_sys_admin_list = node['sql_server']['sysadmins'].join(' ')
else
  sql_sys_admin_list = node['sql_server']['sysadmins']
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

is_sqlserver_installed = is_package_installed?(package_name)

filename = File.basename(package_url).downcase
iso_install = File.extname(filename) == ".iso"
download_path = "#{Chef::Config['file_cache_path']}/#{filename}"

if iso_install
  remote_file download_path do
    source package_url
    checksum package_checksum
    not_if {is_sqlserver_installed}
  end
  
  mount_log_path = "#{Chef::Config['file_cache_path']}/#{filename}_Mount_Log.txt"
  mount_drive_path = "#{Chef::Config['file_cache_path']}/#{filename}_Mount_Drive.txt"
  powershell_script "Mount #{filename}" do
    code <<-EOH
      Mount-DiskImage -ImagePath "#{download_path}"
          if ($? -eq $True)
      {
        echo "Success: #{filename} was mounted successfully." > #{mount_log_path}
        $SQL_Server_ISO_Drive_Letter = @(gwmi -Class Win32_LogicalDisk | ?{$_.VolumeName -eq 'SqlServer'} | %{$_.DeviceId})[0]
        $url = "$SQL_Server_ISO_Drive_Letter/setup.exe"

        echo $url > #{mount_drive_path}
        exit 0;
      }
      
      if ($? -eq $False)
          {
        echo "Fail: #{filename} was not mount successfully." > #{mount_log_path}
        exit 2;
          }
      EOH
    not_if {is_sqlserver_installed}
  end

  ruby_block 'Get installation url' do
    block do
      encoding_options = {
          :invalid           => :replace,  # Replace invalid byte sequences
          :undef             => :replace,  # Replace anything not defined in ASCII
          :replace           => '',        # Use a blank for those replacements
          :universal_newline => true       # Always break lines with \n
        }
        package_url = File.read(mount_drive_path).encode(Encoding.find('ASCII'), encoding_options)
    end
    not_if {is_sqlserver_installed}
  end

  package_checksum = ""
end

windows_package package_name do
  source package_url
  checksum package_checksum
  timeout node['sql_server']['server']['installer_timeout']
  installer_type :custom
  options "/q /ConfigurationFile=#{config_file_path}"
  action :install
  not_if {is_sqlserver_installed}
end

service service_name do
  action :nothing
  not_if {is_sqlserver_installed}
end

# set the static tcp port
registry_key static_tcp_reg_key do
  values [{ name: 'TcpPort', type: :string, data: node['sql_server']['port'].to_s },
          { name: 'TcpDynamicPorts', type: :string, data: '' }]
  recursive true
  notifies :restart, "service[#{service_name}]", :immediately
  not_if {is_sqlserver_installed}
end

include_recipe 'sql_server::client'

if iso_install
  powershell_script 'Dismount #{filename}' do
    code <<-EOH
      Dismount-DiskImage -ImagePath "#{download_path}"
      EOH
    not_if {is_sqlserver_installed}
  end
end