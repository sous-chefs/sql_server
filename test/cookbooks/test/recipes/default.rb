sql_server_install 'Install SQL' do
  sa_password 'Supersecurepassword123'
end

sql_server_configure 'SQLEXPRESS'
