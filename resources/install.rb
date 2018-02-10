
#
# Cookbook:: sql_server
# Resource:: install
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

property :sql_reboot, [true, false], default: true
property :security_mode, String, equal_to: ['Windows Authentication', 'Mixed Mode Authentication'], default: 'Windows Authentication'
property :sa_password, String
property :sysadmins, [Array, String], default: ['Administrator']
property :agent_account, String, default: 'NT AUTHORITY\NETWORK SERVICE'
property :agent_startup, String, equal_to: ['Automatic', 'Manual', 'Disabled', 'Automatic (Delayed Start)'], default: 'Disabled'
property :agent_account_pwd, String
property :rs_account, String, default: 'NT AUTHORITY\NETWORK SERVICE'
property :rs_account_pwd, String
property :rs_startup, String, equal_to: ['Automatic', 'Manual', 'Disabled', 'Automatic (Delayed Start)'], default: 'Automatic'
property :rs_mode, String, default: 'FilesOnlyMode'
property :as_sysadmins, [Array, String], default: ['Administrator']
property :sql_account, String, default: 'NT AUTHORITY\NETWORK SERVICE'
property :sql_account_pwd, String
property :browser_startup, String, equal_to: ['Automatic', 'Manual', 'Disabled', 'Automatic (Delayed Start)'], default: 'Disabled'
property :version, [Integer, String], default: '2012'
property :source_url, String
property :package_name, String
property :package_checksum, String
property :installer_timeout, Integer, default: 1500
property :accept_eula, [true, false], default: false
property :product_key, String
property :update_enabled, [true, false], default: true
property :update_source, String, default: 'MU'
property :instance_name, String, default: 'SQLEXPRESS'
property :feature, [Array, String], default: %w(SQLENGINE REPLICATION SNAC_SDK)
property :install_dir, String, default: 'C:\Program Files\Microsoft SQL Server'
property :instance_dir, String, default: 'C:\Program Files\Microsoft SQL Server'
property :sql_data_dir, String
property :sql_backup_dir, String
property :sql_user_db_dir, String
property :sql_user_db_log_dir, String
property :sql_temp_db_dir, String
property :sql_temp_db_log_dir, String
property :filestream_level, Integer, equal_to: [0, 1, 2, 3], default: 0
property :filestream_share_name, String, default: 'MSSQLSERVER'
property :sql_collation, String
property :dreplay_ctlr_admins, [Array, String], default: ['Administrator']
property :dreplay_client_name, String
property :netfx35_install, [true, false], default: true
property :netfx35_source, String
property :polybase_port_range, String, default: '16450-16460'
property :is_master_port, String, default: '8391'
property :is_master_ssl_cert, String
property :is_master_cert_thumbprint, String
property :is_worker_master_url, String

action :install do
  if new_resource.feature.include?('DREPLAY_CLT') && new_resource.dreplay_client_name.nil?
    ::Chef::Application.fatal!('You cannot select include the DREPLAY_CLT feature with specifing a controller to target.')
  end

  if new_resource.security_mode == 'Mixed Mode Authentication' && new_resource.sa_password.nil?
    ::Chef::Application.fatal!('You cannot have set the security mode to "Mixed Mode Authenication" without specifying the sa_password property')
  end

  if new_resource.netfx35_install
    windows_feature ['NET-Framework-Features', 'NET-Framework-Core'] do
      action :install
      source new_resource.netfx35_source if new_resource.netfx35_source
      install_method :windows_feature_powershell
    end
  end

  config_file_path = ::File.join(Chef::Config[:file_cache_path], 'ConfigurationFile.ini')

  x86_64 = node['kernel']['machine'] =~ /x86_64/

  sql_sys_admin_list = build_admin_list(new_resource.sysadmins)
  as_sys_admin_list = build_admin_list(new_resource.as_sysadmins)
  dreplay_ctlr_admin_list = build_admin_list(new_resource.dreplay_ctlr_admins)

  shared_wow_dir = new_resource.install_dir.gsub(/Program Files/, 'Program Files (x86)')

  template config_file_path do
    source '_ConfigurationFile.ini.erb'
    cookbook 'sql_server'
    variables(
      sqlSysAdminList: sql_sys_admin_list,
      version: new_resource.version,
      accept_eula: new_resource.accept_eula,
      product_key: new_resource.product_key,
      sa_password: new_resource.sa_password,
      agent_account: new_resource.agent_account,
      agent_startup: new_resource.agent_startup,
      update_enabled: new_resource.update_enabled,
      update_source: new_resource.update_source,
      instance_name: new_resource.instance_name,
      feature_list: new_resource.feature,
      install_dir: new_resource.install_dir,
      shared_wow_dir: shared_wow_dir,
      instance_dir: new_resource.instance_dir,
      sql_data_dir: new_resource.sql_data_dir,
      sql_backup_dir: new_resource.sql_backup_dir,
      sql_user_db_dir: new_resource.sql_user_db_dir,
      sql_user_db_log_dir: new_resource.sql_user_db_log_dir,
      sql_temp_db_dir: new_resource.sql_temp_db_dir,
      sql_temp_db_log_dir: new_resource.sql_temp_db_log_dir,
      filestream_level: new_resource.filestream_level,
      filestream_share_name: new_resource.filestream_share_name,
      sql_collation: new_resource.sql_collation,
      sql_account: new_resource.sql_account,
      browser_startup: new_resource.browser_startup,
      rs_account: new_resource.rs_account,
      rs_startup: new_resource.rs_startup,
      rs_mode: new_resource.rs_mode,
      asSysAdminList: as_sys_admin_list,
      dreplayCtlrList: dreplay_ctlr_admin_list,
      dreplay_client_name: new_resource.dreplay_client_name,
      security_mode: new_resource.security_mode,
      polybase_port_range: new_resource.polybase_port_range,
      is_master_port: new_resource.is_master_port,
      is_master_ssl_cert: new_resource.is_master_ssl_cert,
      is_master_cert_thumbprint: new_resource.is_master_cert_thumbprint,
      is_worker_master_url: new_resource.is_worker_master_url
    )
    sensitive true
  end

  package_url = new_resource.source_url ||
                ::SqlServer::Helper.sql_server_url(new_resource.version, x86_64) ||
                ::Chef::Application.fatal!("No package URL matches '#{new_resource.version}'. source_url property must be set or version property must match a supported version.")

  install_name = new_resource.package_name ||
                 ::SqlServer::Helper.sql_server_package_name(new_resource.version, x86_64) ||
                 ::Chef::Application.fatal!("No package name matches '#{new_resource.version}'. package_name property must be set or version property must match a supported version.")

  install_checksum = new_resource.package_checksum ||
                     ::SqlServer::Helper.sql_server_checksum(new_resource.version, x86_64) ||
                     ::Chef::Application.fatal!("No package checksum matches '#{new_resource.version}'. package_checksum property must be set or version property must match a supported version.")

  # Build safe password command line options for the installer
  # see http://technet.microsoft.com/library/ms144259
  passwords_options = {
    AGTSVCPASSWORD: new_resource.agent_account_pwd,
    RSSVCPASSWORD:  new_resource.rs_account_pwd,
    SQLSVCPASSWORD: new_resource.sql_account_pwd,
  }.map do |option, attribute|
    next unless attribute
    # Escape password double quotes and backslashes
    safe_password = attribute.gsub(/["\\]/, '\\\\\0')
    # When the number of double quotes is odd, we need to escape the enclosing quotes
    enclosing_escape = safe_password.count('"').odd? ? '^' : ''
    "/#{option}=\"#{safe_password}#{enclosing_escape}\""
  end.compact.join ' '

  package install_name do # ~FC009
    source package_url
    checksum install_checksum
    timeout new_resource.installer_timeout
    installer_type :custom
    options "/q /ConfigurationFile=#{config_file_path} #{passwords_options}"
    action :install
    notifies :reboot_now, 'reboot[sql server install]' if new_resource.sql_reboot
    returns [0, 42, 127, 3010]
  end

  # SQL Server requires a reboot to complete your install
  reboot 'sql server install' do
    action :nothing
    reason 'Needs to reboot after installing SQL Server'
    delay_mins 1
  end
end

action_class do
  include ::SqlServer::Helper

  def build_admin_list(admin_list)
    if admin_list.is_a? Array
      admin_list.map { |account| %("#{account}") }.join(' ')
    else
      %("#{admin_list}")
    end
  end
end
