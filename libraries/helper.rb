#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: sql_server
# Library:: helper
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

require 'chef/mixin/shell_out'

module SqlServer
  module Helper
    extend Chef::Mixin::ShellOut

    def self.reg_version_string(version)
      case version.to_s # to_s to make sure someone didn't pass us an int
      when '2008' then 'MSSQL10.'
      when '2008R2' then 'MSSQL10_50.'
      when '2012' then 'MSSQL11.'
      when '2014' then 'MSSQL12.'
      when '2016' then 'MSSQL13.'
      when '2017' then 'MSSQL14.'
      else raise "Unsupported sql_server version '#{version}'. Please open a PR to add support for this version."
      end
    end

    def self.install_dir_version(version)
      case version.to_s # to_s to make sure someone didn't pass us an int
      when '2008' then '100'
      when '2012' then '110'
      when '2014' then '120'
      when '2016' then '130'
      when '2017' then '140'
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
        when '2008R2' then 'https://download.microsoft.com/download/D/1/8/D1869DEC-2638-4854-81B7-0F37455F35EA/SQLEXPR_x64_ENU.exe'
        when '2012' then 'https://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x64/SQLEXPR_x64_ENU.exe'
        when '2014' then 'https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/Express%2064BIT/SQLEXPR_x64_ENU.exe'
        when '2016' then 'https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPR_x64_ENU.exe'
        when '2017' then 'https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SQLEXPR_x64_ENU.exe'
        end
      else
        case version.to_s
        when '2008R2' then 'http://download.microsoft.com/download/D/1/8/D1869DEC-2638-4854-81B7-0F37455F35EA/SQLEXPR32_x86_ENU.exe'
        when '2012' then 'https://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x86/SQLEXPR_x86_ENU.exe'
        when '2014' then 'https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/Express%2032BIT/SQLEXPR_x86_ENU.exe'
        end
      end
    end

    def self.sql_server_package_name(version, x86_64)
      if x86_64
        case version.to_s # to_s to make sure someone didn't pass us an int
        when '2008R2' then 'Microsoft SQL Server 2008 R2 (64-bit)'
        when '2012' then 'Microsoft SQL Server 2012 (64-bit)'
        when '2014' then 'Microsoft SQL Server 2014 (64-bit)'
        when '2016' then 'Microsoft SQL Server 2016 (64-bit)'
        when '2017' then 'Microsoft SQL Server 2017 (64-bit)'
        end
      else
        case version.to_s
        when '2008R2' then 'Microsoft SQL Server 2008 R2 (32-bit)'
        when '2012' then 'Microsoft SQL Server 2012 (32-bit)'
        when '2014' then 'Microsoft SQL Server 2014 (32-bit)'
        end
      end
    end

    def self.sql_server_checksum(version, x86_64)
      if x86_64
        case version.to_s # to_s to make sure someone didn't pass us an int
        when '2008R2' then '8ebf6bdd805f3326d5b9a35a129af276c7fe99bfca64ac0cfe0ffc66311dfe09'
        when '2012' then '7f5e3d40b85fba2da5093e3621435c209c4ac90d34219bab8878e93a787cf29f'
        when '2014' then '8f712faefee9cef1d15494c9d6cf5ad3b45ec06d0b2c247f8384a221baaadda7'
        when '2016' then '2A5B64AE64A8285C024870EC4643617AC5146894DD59DD560E75CEA787BF9333'
        when '2017' then 'F857FF82145E196BF85AF32EEB0193FE38302E57B30BEB54E513630C60D83E0D'
        end
      else
        case version.to_s
        when '2008R2' then '602d6525261ef65612ba713daddfbe7c73869dfdf19988db31fa2e66c0d38c04'
        when '2012' then '9bdd6a7be59c00b0201519b9075601b1c18ad32a3a166d788f3416b15206d6f5'
        when '2014' then 'dfed00b9d7adf0aa200e6e1593a4411b370fc1a3e8d7238a364a0eb775924898'
        end
      end
    end
  end
end
