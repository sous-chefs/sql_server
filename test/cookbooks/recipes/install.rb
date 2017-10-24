x86_64 = node['kernel']['machine'] =~ /x86_64/

package_name = SqlServer::Helper.sql_server_package_name(version, x86_64)

sql_server_install package_name do
  action :install
end
