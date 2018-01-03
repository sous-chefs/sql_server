#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: sql_server
# Recipe:: client
#
# Copyright:: 2011-2017, Chef Software, Inc.
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

if node['platform_version'].to_f == 6.1
  windows_feature 'NetFx3' do
    action :install
    install_method :windows_feature_powershell
  end
end

%w( native_client command_line_utils clr_types smo ps_extensions ).each do |pkg|
  package node['sql_server'][pkg]['package_name'] do # ~FC009
    source node['sql_server'][pkg]['url']
    checksum node['sql_server'][pkg]['checksum']
    installer_type :msi
    options "IACCEPTSQLNCLILICENSETERMS=#{node['sql_server']['accept_eula'] ? 'YES' : 'NO'}"
    action :install
  end
end

# update path
windows_path "#{node['sql_server']['install_dir']}\\#{SqlServer::Helper.install_dir_version(node['sql_server']['version'])}\\Tools\\Binn" do
  action :add
end
