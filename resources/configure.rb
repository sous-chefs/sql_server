
#
# Cookbook:: sql_server
# Resource:: configure
#
# Copyright:: 2017, Chef Software, Inc.
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

property :reg_version, String
property :version, [Integer, String], default: '2012'
property :tcp_enabled, [true, false], default: true
property :sql_port, Integer, default: 1433
property :tcp_dynamic_ports, String, default: ''
property :np_enabled, [true, false], default: false
property :sm_enabled, [true, false], default: true
property :via_default_port, String, default: '0:1433'
property :via_enabled, [true, false], default: false
property :via_listen_info, String, default: '0:1433'
property :agent_startup, String, equal_to: ['Automatic', 'Manual', 'Disabled', 'Automatic (Delayed Start)'], default: 'Disabled'

action :service do
  # Compute registry version based on sql server version
  reg_version = new_resource.reg_version || ::SqlServer::Helper.reg_version_string(new_resource.version)

  reg_prefix = "HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\#{reg_version}#{new_resource.name}\\MSSQLServer"

  # Configure Tcp settings - static tcp ports
  registry_key "#{reg_prefix}\\SuperSocketNetLib\\Tcp\\IPAll" do
    values [{ name: 'Enabled', type: :dword, data: new_resource.tcp_enabled ? 1 : 0 },
            { name: 'TcpPort', type: :string, data: new_resource.sql_port.to_s },
            { name: 'TcpDynamicPorts', type: :string, data: new_resource.tcp_dynamic_ports.to_s }]
    recursive true
    notifies :restart, "service[#{service_name}]", :delayed
  end

  # Configure Named Pipes settings
  registry_key "#{reg_prefix}\\SuperSocketNetLib\\Np" do
    values [{ name: 'Enabled', type: :dword, data: new_resource.np_enabled ? 1 : 0 }]
    recursive true
    notifies :restart, "service[#{service_name}]", :delayed
  end

  # Configure Shared Memory settings
  registry_key "#{reg_prefix}\\SuperSocketNetLib\\Sm" do
    values [{ name: 'Enabled', type: :dword, data: new_resource.sm_enabled ? 1 : 0 }]
    recursive true
    notifies :restart, "service[#{service_name}]", :delayed
  end

  # Configure Via settings
  registry_key "#{reg_prefix}\\SuperSocketNetLib\\Via" do
    values [{ name: 'DefaultServerPort', type: :string, data: new_resource.via_default_port.to_s },
            { name: 'Enabled', type: :dword, data: new_resource.via_enabled ? 1 : 0 },
            { name: 'ListenInfo', type: :string, data: new_resource.via_listen_info.to_s }]
    recursive true
    notifies :restart, "service[#{service_name}]", :delayed
  end

  # If you have declared an agent account it will restart both the
  # agent service and the sql service. If not only the sql service
  if new_resource.agent_startup == 'Automatic'
    service agent_service_name do
      action [:start, :enable]
    end
  end

  service service_name do
    action [:start, :enable]
    restart_command %(powershell.exe -C "restart-service '#{service_name}' -force")
  end
end

action_class do
  include ::SqlServer::Helper

  def service_name
    (new_resource.name != 'MSSQLSERVER') ? "MSSQL$#{new_resource.name}" : new_resource.name
  end

  def agent_service_name
    (new_resource.name == 'MSSQLSERVER') ? 'SQLSERVERAGENT' : "SQLAgent$#{new_resource.name}"
  end
end
