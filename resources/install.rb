action :install do
  Chef::Application.fatal!("node['sql_server']['server_sa_password'] must be set for this cookbook to run") if node['sql_server']['server_sa_password'].nil?

  config_file_path = ::File.join(Chef::Config[:file_cache_path], 'ConfigurationFile.ini')

  sql_sys_admin_list = if node['sql_server']['sysadmins'].is_a? Array
                         node['sql_server']['sysadmins'].map { |account| %("#{account}") }.join(' ') # surround each in quotes, space delimit list
                      else
                        %("#{node['sql_server']['sysadmins']}") # surround in quotes
                      end

  template config_file_path do
    source 'ConfigurationFile.ini.erb'
    cookbook 'sql_server'
    variables(
      sqlSysAdminList: sql_sys_admin_list
    )
  end

  version = node['sql_server']['version']
  x86_64 = node['kernel']['machine'] =~ /x86_64/

  package_url = node['sql_server']['server']['url'] ||
                ::SqlServer::Helper.sql_server_url(version, x86_64) ||
                ::Chef::Application.fatal!("No package URL matches '#{version}'. node['sql_server']['server']['url'] must be set or node['sql_server']['version'] must match a supported version.")

  package_name = node['sql_server']['server']['package_name'] ||
                ::SqlServer::Helper.sql_server_package_name(version, x86_64) ||
                ::Chef::Application.fatal!("No package name matches '#{version}'. node['sql_server']['server']['package_name'] must be set or node['sql_server']['version'] must match a supported version.")

  package_checksum = node['sql_server']['server']['checksum'] ||
                    ::SqlServer::Helper.sql_server_checksum(version, x86_64) ||
                    ::Chef::Application.fatal!("No package checksum matches '#{version}'. node['sql_server']['server']['checksum'] must be set or node['sql_server']['version'] must match a supported version.")

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

  package package_name do
    source package_url
    checksum package_checksum
    timeout node['sql_server']['server']['installer_timeout']
    installer_type :custom
    options "/q /ConfigurationFile=#{config_file_path} #{passwords_options}"
    action :install
    notifies :request_reboot, 'reboot[sql server install]'
    returns [0, 42, 127, 3010]
  end

  # SQL Server requires a reboot to complete your install
  reboot 'sql server install' do
    action :nothing
    reason 'Needs to reboot after installing SQL Server'
    only_if { reboot_pending? }
  end

  include_recipe 'sql_server::configure'
end

action_class do
  include ::SqlServer::Helper
end
