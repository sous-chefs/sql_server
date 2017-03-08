#
# Cookbook:: sql_server
# Resource:: client
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
#

property :version, String, name_attribute: true
property :accept_license, [true, false], required: true
property :package_sources, Hash, default: {}

action :install do
  if node['platform_version'].to_f == 6.1
    windows_feature 'NetFx3' do
      action :install
    end
  end

  package_data = new_resource.package_sources.empty? ? client_package_source(new_resource.version) : new_resource.package_sources

  package_data.keys.each do |pkg|
    package node['sql_server'][pkg]['package_name'] do
      source node['sql_server'][pkg]['url']
      checksum node['sql_server'][pkg]['checksum']
      installer_type :msi
      options "IACCEPTSQLNCLILICENSETERMS=#{new_resource.accept_license ? 'YES' : 'NO'}"
      action :install
    end
  end

  # update path
  windows_path "#{node['sql_server']['install_dir']}\\#{SqlServer::Helper.install_dir_version(new_resource.version)}\\Tools\\Binn" do
    action :add
  end
end
