#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: sql_server
# Library:: helper
#
# Copyright:: 2011-2016, Chef Software, Inc.
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

    def self.reg_version_string(version)
      case version.to_s # to_s to make sure someone didn't pass us an int
      when '2008' then 'MSSQL10.'
      when '2008R2' then 'MSSQL10_50.'
      when '2012' then 'MSSQL11.'
      when '2014' then 'MSSQL12.'
      when '2016' then 'MSSQL13.'
      else raise "Unsupported sql_server version '#{version}'. Please open a PR to add support for this version."
      end
    end

    def self.install_dir_version(version)
      case version.to_s # to_s to make sure someone didn't pass us an int
      when '2008' then '100'
      when '2012' then '110'
      when '2014' then '120'
      when '2016' then '130'
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
        when '2016' then 'https://download.microsoft.com/download/9/A/E/9AE09369-C53D-4FB7-985B-5CF0D547AE9F/SQLServer2016-SSEI-Expr.exe'
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
        when '2016' then 'bdb84067de0187234673de73216818fcfd774501307e84b8cba327b948ef4ca6'
        end
      else
        case version.to_s
        when '2008R2' then '602d6525261ef65612ba713daddfbe7c73869dfdf19988db31fa2e66c0d38c04'
        when '2012' then '9bdd6a7be59c00b0201519b9075601b1c18ad32a3a166d788f3416b15206d6f5'
        when '2014' then 'dfed00b9d7adf0aa200e6e1593a4411b370fc1a3e8d7238a364a0eb775924898'
        end
      end
    end


    if node['kernel']['machine'] =~ /x86_64/
      case node['sql_server']['version']
      when '2008R2SP2'
        default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/sqlncli_amd64.msi'
        default['sql_server']['native_client']['checksum']          = '77cb222d4e573e0aafb3d0339c2018eec2b8d7335388d0a2738e1b776ab0b2be'
        default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

        default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/SqlCmdLnUtils_amd64.msi'
        default['sql_server']['command_line_utils']['checksum']     = '76233ab33d3d9905175e3faa4f76ea2337ab750082ef06343bed4fcc42a16432'
        default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

        default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/SQLSysClrTypes_amd64.msi'
        default['sql_server']['clr_types']['checksum']              = 'a2de5e202d3e4eecb91c3249da08d9270e1706a6d24148289e29814759d2ac59'
        default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x64)'

        default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/SharedManagementObjects_amd64.msi'
        default['sql_server']['smo']['checksum']                    = '50dc27b5ecf13456737fe7d50209975461129f2f6d6b14c0b051921b6266cca2'
        default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x64)'

        default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/PowerShellTools_amd64.msi'
        default['sql_server']['ps_extensions']['checksum']          = '9ab956f5cfed4c3490550c3b136a400213f5c07f62a00ee0d484470104bea565'
        default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2008 R2'

      when '2012'
        default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/sqlncli.msi'
        default['sql_server']['native_client']['checksum']          = '1364bf4c37a09ce3c87b029a2db4708f066074b1eaa22aa4e86d437b7b05203d'
        default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2012 Native Client'

        default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SqlCmdLnUtils.msi'
        default['sql_server']['command_line_utils']['checksum']     = 'ad9186c1acc786c116d0520fc642f6b315c4b8b62fc589d8e2763a2da4c80347'
        default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2012 Command Line Utilities'

        default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SQLSysClrTypes.msi'
        default['sql_server']['clr_types']['checksum']              = '674c396e9c9bf389dd21cec0780b3b4c808ff50c570fa927b07fa620db7d4537'
        default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x64)'

        default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SharedManagementObjects.msi'
        default['sql_server']['smo']['checksum']                    = 'ed753d85b51e7eae381085cad3dcc0f29c0b72f014f8f8fba1ad4e0fe387ce0a'
        default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2012 Management Objects (x64)'

        default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/PowerShellTools.MSI'
        default['sql_server']['ps_extensions']['checksum']          = '532261175cc6116439b89be476fa403737d85f2ee742f2958cf9c066bcbdeaba'
        default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2012'
      end

    else
      case node['sql_server']['version']
      when '2008R2SP2'
        default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/sqlncli_x86.msi'
        default['sql_server']['native_client']['checksum']          = 'ab5a889ec8ecaf6076422684e6914fd235216b6c0d2aba05564a126181a855d8'
        default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

        default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/SqlCmdLnUtils_x86.msi'
        default['sql_server']['command_line_utils']['checksum']     = 'f053c37bb6c0bb0eab581196f815da976c2658c756e15b2198a9a4033ce522cd'
        default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

        default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/SQLSysClrTypes_x86.msi'
        default['sql_server']['clr_types']['checksum']              = '4e23cb229bc6d062a05bf83c206ff26a8c7405f223fd58e48b5ee3197738d32d'
        default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types'

        default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/SharedManagementObjects_x86.msi'
        default['sql_server']['smo']['checksum']                    = 'b34d88912ddf82bda7754f3f0c98f11d97c4dd89256cca8f49aaa77829e435f0'
        default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects'

        default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/F/7/B/F7B7A246-6B35-40E9-8509-72D2F8D63B80/PowerShellTools_x86.msi'
        default['sql_server']['ps_extensions']['checksum']          = '69f12c5548368eb12f019dc8b48ca6db3312d4fb0c84c07e3be4d57f3d44d34b'
        default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2008 R2'

      when '2012'
        default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/sqlncli.msi'
        default['sql_server']['native_client']['checksum']          = '9bb7b584ecd2cbe480607c4a51728693b2c99c6bc38fa9213b5b54a13c34b7e2'
        default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2012 Native Client'

        default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/SqlCmdLnUtils.msi'
        default['sql_server']['command_line_utils']['checksum']     = '0257292d2b038f012777489c9af51ea75b7bee92efa9c7d56bc25803c9e39801'
        default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2012 Command Line Utilities'

        default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/SQLSysClrTypes.msi'
        default['sql_server']['clr_types']['checksum']              = 'a9cf3e40c9a06dd9e9d0f689f3636ba3f58ec701b9405ba67881a802271bbba1'
        default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x86)'

        default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/SharedManagementObjects.msi'
        default['sql_server']['smo']['checksum']                    = 'afc0eccb35c979801344b0dc04556c23c8b957f1bdee3530bc1a59d5c704ce64'
        default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2012 Management Objects (x86)'

        default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/PowerShellTools.MSI'
        default['sql_server']['ps_extensions']['checksum']          = '6a181aeb27b4baec88172c2e80f33ea3419c7e86f6aea0ed1846137bc9144fc6'
        default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2012'
      end

    end

  end
end
