#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: sql_server
# Library:: helper
#
# Copyright:: Copyright (c) 2011-2016 Chef Software, Inc.
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

require 'chef/mixin/shell_out'

module SqlServer
  class Helper
    extend Chef::Mixin::ShellOut

    def self.firewall_rule_enabled?(rule_name = nil)
      cmd = shell_out("netsh advfirewall firewall show rule \"#{rule_name}\"")
      cmd.stderr.empty? && (cmd.stdout =~ /Enabled:\s*Yes/i)
    end

    def self.sql_server_url(version, x86_64)
      if x86_64
        case version
        when '2008R2'
          'http://download.microsoft.com/download/D/1/8/D1869DEC-2638-4854-81B7-0F37455F35EA/SQLEXPR_x64_ENU.exe'
        when '2012'
          'http://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x64/SQLEXPR_x64_ENU.exe'
        end
      else
        case version
        when '2008R2'
          'http://download.microsoft.com/download/D/1/8/D1869DEC-2638-4854-81B7-0F37455F35EA/SQLEXPR32_x86_ENU.exe'
        when '2012'
          'http://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x86/SQLEXPR_x86_ENU.exe'
        end
      end
    end

    def self.sql_server_package_name(version, x86_64)
      if x86_64
        case version
        when '2008R2'
          'Microsoft SQL Server 2008 R2 (64-bit)'
        when '2012'
          'Microsoft SQL Server 2012 (64-bit)'
        end
      else
        case version
        when '2008R2'
          'Microsoft SQL Server 2008 R2 (32-bit)'
        when '2012'
          'Microsoft SQL Server 2012 (32-bit)'
        end
      end
    end

    def self.sql_server_checksum(version, x86_64)
      if x86_64
        case version
        when '2008R2'
          '8ebf6bdd805f3326d5b9a35a129af276c7fe99bfca64ac0cfe0ffc66311dfe09'
        when '2012'
          '7f5e3d40b85fba2da5093e3621435c209c4ac90d34219bab8878e93a787cf29f'
        end
      else
        case version
        when '2008R2'
          '602d6525261ef65612ba713daddfbe7c73869dfdf19988db31fa2e66c0d38c04'
        when '2012'
          '9bdd6a7be59c00b0201519b9075601b1c18ad32a3a166d788f3416b15206d6f5'
        end
      end
    end
  end
end
