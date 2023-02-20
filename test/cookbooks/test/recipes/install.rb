# Test install of SQL Defaults

sql_server_install 'Install SQL' do
  sa_password 'Supersecurepassword123'
  action :install
end

sql_server_configure 'SQLEXPRESS'
