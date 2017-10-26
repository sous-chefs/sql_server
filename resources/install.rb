property :sql_reboot, kind_of: [TrueClass, FalseClass], default: true
property :security_mode, kind_of: String, equal_to: ['Windows Authenication', 'Mixed Mode Authentication'], default: 'Windows Authenication'
property :sa_password, kind_of: String
property :sysadmins, kind_of: [Array, String], required: true, default: ['Administrator']
property :agent_account, kind_of: String, default: 'NT AUTHORITY\NETWORK SERVICE'
property :agent_startup, kind_of: String, equal_to: ['Automatic', 'Manual', 'Disabled', 'Automatic (Delayed Start)'], default: 'Automatic'
property :agent_account_pwd, kind_of: String
property :rs_account, kind_of: String, default: 'NT AUTHORITY\NETWORK SERVICE'
property :rs_account_pwd, kind_of: String
property :rs_startup, kind_of: String, equal_to: ['Automatic', 'Manual', 'Disabled', 'Automatic (Delayed Start)'], default: 'Automatic'
property :rs_mode, kind_of: String, default: 'FilesOnlyMode'
property :as_sysadmins, kind_of: [Array, String], default: ['Administrator']
property :sql_account, kind_of: String, default: 'NT AUTHORITY\NETWORK SERVICE'
property :sql_account_pwd, kind_of: String
property :browser_startup, kind_of: String, equal_to: ['Automatic', 'Manual', 'Disabled', 'Automatic (Delayed Start)'], default: 'Disabled'
property :version, kind_of: String, default: '2012'
property :source_url, kind_of: String
property :package_name, kind_of: String
property :package_checksum, kind_of: String
property :installer_timeout, kind_of: Integer, default: 1500
property :accept_eula, kind_of: [TrueClass, FalseClass], default: false
property :product_key, kind_of: String
property :update_enabled, kind_of: [TrueClass, FalseClass], default: true
property :instance_name, kind_of: String, default: 'SQLEXPRESS'
property :feature, kind_of: [Array, String], default: %w(SQLENGINE REPLICATION SNAC_SDK)
property :install_dir, kind_of: String, default: 'C:\Program Files\Microsoft SQL Server'
property :instance_dir, kind_of: String, default: 'C:\Program Files\Microsoft SQL Server'
property :sql_data_dir, kind_of: String
property :sql_backup_dir, kind_of: String
property :sql_user_db_dir, kind_of: String
property :sql_user_db_log_dir, kind_of: String
property :sql_temp_db_dir, kind_of: String
property :sql_temp_db_log_dir, kind_of: String
property :filestream_level, kind_of: Integer, equal_to: [0, 1, 2, 3], default: 0
property :filestream_share_name, kind_of: String, default: 'MSSQLSERVER'
property :sql_collation, kind_of: String
property :dreplay_ctlr_admins, kind_of: [Array, String], default: ['Administrator']
property :dreplay_client_name, kind_of: String

action :install do
  if new_resource.feature.include?('DREPLAY_CLT') && new_resource.dreplay_client_name.nil?
    ::Chef::Application.fatal!('You cannot select include the DREPLAY_CLT feature with specifing a controller to target.')
  end

  if new_resource.security_mode == 'Mixed Mode Authentication' && new_resource.sa_password.nil?
    ::Chef::Application.fatal!('You cannot have set the security mode to "Mixed Mode Authenication" without specifying the sa_password property')
  end

  config_file_path = ::File.join(Chef::Config[:file_cache_path], 'ConfigurationFile.ini')

  x86_64 = node['kernel']['machine'] =~ /x86_64/

  sql_sys_admin_list = if new_resource.sysadmins.is_a? Array
                         new_resource.sysadmins.map { |account| %("#{account}") }.join(' ') # surround each in quotes, space delimit list
                       else
                         %("#{new_resource.sysadmins}") # surround in quotes
                       end

  as_sys_admin_list = if new_resource.as_sysadmins.is_a? Array
                        new_resource.as_sysadmins.map { |account| %("#{account}") }.join(' ')
                      else
                        %("#{new_resource.as_sysadmins}")
                      end

  dreplay_ctlr_admin_list = if new_resource.dreplay_ctlr_admins.is_a? Array
                              new_resource.dreplay_ctlr_admins.map { |account| %("#{account}") }.join(' ')
                            else
                              %("#{new_resource.dreplay_ctlr_admins}")
                            end

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
      security_mode: new_resource.security_mode
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

  package install_name do
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
end
