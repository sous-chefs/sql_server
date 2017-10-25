property :name, kind_of: String, name_property: true
property :sql_reboot, kind_of: [TrueClass, FalseClass], default: true
property :sa_password, kind_of: String, required: true
property :sysadmins, kind_of: [Array, String], required: true
property :version, kind_of: String, default: '2012'
property :source_url, kind_of: String
property :package_name, kind_of: String
property :package_checksum, kind_of: String

action :install do
  config_file_path = ::File.join(Chef::Config[:file_cache_path], 'ConfigurationFile.ini')

  sql_sys_admin_list = if new_resource.sysadmins.is_a? Array
                         new_resource.sysadmins.map { |account| %("#{account}") }.join(' ') # surround each in quotes, space delimit list
                       else
                         %("#{new_resource.sysadmins}") # surround in quotes
                       end

  template config_file_path do
    source 'ConfigurationFile.ini.erb'
    cookbook 'sql_server'
    variables(
      sqlSysAdminList: sql_sys_admin_list
    )
    sensitive true
  end

  x86_64 = node['kernel']['machine'] =~ /x86_64/

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
    AGTSVCPASSWORD: node['sql_server']['agent_account_pwd'],
    RSSVCPASSWORD:  node['sql_server']['rs_account_pwd'],
    SQLSVCPASSWORD: node['sql_server']['sql_account_pwd'],
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
    timeout node['sql_server']['server']['installer_timeout']
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

  include_recipe 'sql_server::configure'
end

action_class do
  include ::SqlServer::Helper
end
