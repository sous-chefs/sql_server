# Test suite for testing the Enterprise editiions of SQL Server THIS WILL NOT WORK WITHOUT LOCAL INSTALL FILES

# Install any version of SQL Engine
sql_server_install "Install SQL Server #{node['sql_server']['version']}" do
  source_url "C:\\Sources\\SQL_#{node['sql_server']['version']}\\setup.exe"
  version node['sql_server']['version']
  package_checksum node['sql_server']['server']['checksum']
  accept_eula true
  instance_name 'MSSQLSERVER'
  netfx35_install false if node['sql_server']['version'] == 2016
  feature %w(SQLENGINE)
end

sql_server_configure 'MSSQLSERVER' do
  version node['sql_server']['version']
end
