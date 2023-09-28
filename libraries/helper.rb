#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: sql_server
# Library:: helper
#
# Copyright:: 2011-2019, Chef Software, Inc.
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

require 'chef/mixin/shell_out'
require 'chef/util/path_helper'

module SqlServer
  module Helper
    extend Chef::Mixin::ShellOut

    def self.reg_version_string(version)
      case version.to_s # to_s to make sure someone didn't pass us an int
      when '2012' then 'MSSQL11.'
      when '2016' then 'MSSQL13.'
      when '2017' then 'MSSQL14.'
      when '2019' then 'MSSQL15.'
      when '2022' then 'MSSQL16.'
      else raise "Unsupported sql_server version '#{version}'. Please open a PR to add support for this version."
      end
    end

    def self.install_dir_version(version)
      case version.to_s # to_s to make sure someone didn't pass us an int
      when '2012' then '110'
      when '2016' then '130'
      when '2017' then '140'
      when '2019' then '150'
      when '2022' then '160'
      else raise "SQL Server version #{version} not supported. Please open a PR to add support for this version."
      end
    end

    def self.firewall_rule_enabled?(rule_name = nil)
      cmd = shell_out("netsh advfirewall firewall show rule \"#{rule_name}\"")
      cmd.stderr.empty? && (cmd.stdout =~ /Enabled:\s*Yes/i)
    end

    def self.sql_server_url(version, x86_64)
      if x86_64
        case version.to_s # to_s to make sure someone didn't pass us an int
        when '2012' then 'https://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x64/SQLEXPR_x64_ENU.exe'
        when '2016' then 'https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPR_x64_ENU.exe'
        when '2017' then 'https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SQLEXPR_x64_ENU.exe'
        when '2019' then 'https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLEXPR_x64_ENU.exe'
        when '2022' then 'https://download.microsoft.com/download/5/1/4/5145fe04-4d30-4b85-b0d1-39533663a2f1/SQL2022-SSEI-Expr.exe'
        end
      else
        case version.to_s
        when '2012' then 'https://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x86/SQLEXPR_x86_ENU.exe'
        end
      end
    end

    def self.sql_server_package_name(version, x86_64)
      if x86_64
        case version.to_s # to_s to make sure someone didn't pass us an int
        when '2012' then 'Microsoft SQL Server 2012 (64-bit)'
        when '2016' then 'Microsoft SQL Server 2016 (64-bit)'
        when '2017' then 'Microsoft SQL Server 2017 (64-bit)'
        when '2019' then 'Microsoft SQL Server 2019 (64-bit)'
        when '2022' then 'Microsoft SQL Server 2022 (64-bit)'
        end
      else
        case version.to_s
        when '2012' then 'Microsoft SQL Server 2012 (32-bit)'
        end
      end
    end

    def self.sql_server_checksum(version, x86_64)
      if x86_64
        case version.to_s # to_s to make sure someone didn't pass us an int
        when '2012' then '7f5e3d40b85fba2da5093e3621435c209c4ac90d34219bab8878e93a787cf29f'
        when '2016' then '2A5B64AE64A8285C024870EC4643617AC5146894DD59DD560E75CEA787BF9333'
        when '2017' then 'F857FF82145E196BF85AF32EEB0193FE38302E57B30BEB54E513630C60D83E0D'
        when '2019' then 'bea033e778048748eb1c87bf57597f7f5449b6a15bac55ddc08263c57f7a1ca8'
        when '2022' then '36e0ec2ac3dd60f496c99ce44722c629209ea7302a2ce9cbfd1e42a73510d7b6'
        end
      else
        case version.to_s
        when '2012' then '9bdd6a7be59c00b0201519b9075601b1c18ad32a3a166d788f3416b15206d6f5'
        end
      end
    end
  end
end
