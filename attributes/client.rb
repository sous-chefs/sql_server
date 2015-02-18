#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: sql_server
# Attribute:: client
#
# Copyright:: Copyright (c) 2011 Chef Software, Inc.
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

if kernel['machine'] =~ /x86_64/
  case node['sql_server']['version'] 

  when '2008R2'
    default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/sqlncli.msi'
    default['sql_server']['native_client']['checksum']          = '012aca6cef50ed784f239d1ed5f6923b741d8530b70d14e9abcb3c7299a826cc'
    default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

    default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/SqlCmdLnUtils.msi'
    default['sql_server']['command_line_utils']['checksum']     = '5a321cad6c5f0f5280aa73ab8ed695f8a6369fa00937df538a971729552340b8'
    default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

    default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/SQLSysClrTypes.msi'
    default['sql_server']['clr_types']['checksum']              = '0ad774b0d124c83bbf0f31838ed9c628dd76d83ab2c8c57fd5e2f5305580fff2'
    default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x64)'

    default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/SharedManagementObjects.msi'
    default['sql_server']['smo']['checksum']                    = 'dccec315e3c345a7efb5951f3e9b27512b4e91d73ec48c7196633b7449115b7c'
    default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x64)'

    default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/PowerShellTools.msi'
    default['sql_server']['ps_extensions']['checksum']          = 'eeb46c297523c7de388188ba27263a51b75e85efd478036a12040cc04d4ab344'
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
    default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x64)'

    default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/PowerShellTools.MSI'
    default['sql_server']['ps_extensions']['checksum']          = '532261175cc6116439b89be476fa403737d85f2ee742f2958cf9c066bcbdeaba'
    default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2008 R2'
  end

else
  case node['sql_server']['version']

  when '2008R2'
    default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/sqlncli.msi'
    default['sql_server']['native_client']['checksum']          = '35c4b98f7f5f951cae9939c637593333c44aee920efbd4763b7bdca1e23ac335'
    default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

    default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/SqlCmdLnUtils.msi'
    default['sql_server']['command_line_utils']['checksum']     = 'b39981fa713feedaaf532ab393bf312ec7b5f63bb5f726b9d0e1ae5a65350eee'
    default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

    default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/SQLSysClrTypes.msi'
    default['sql_server']['clr_types']['checksum']              = '6166f2fa57fb971699ff66461434b2418820306c094b5dc3e7df1b827275bf20'
    default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x86)'

    default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/SharedManagementObjects.msi'
    default['sql_server']['smo']['checksum']                    = '4b1ec03bc5cc69481b9da6b2db41ae6d3adeacffe854cc209d125e83a739f937'
    default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x86)'

    default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/PowerShellTools.msi'
    default['sql_server']['ps_extensions']['checksum']          = 'b0d63f8d3e3455fd390dfa0fefebde245bf1a272eb96a968d025f2cbd7842b6c'
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
    default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x86)'

    default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x86/PowerShellTools.MSI'
    default['sql_server']['ps_extensions']['checksum']          = '6a181aeb27b4baec88172c2e80f33ea3419c7e86f6aea0ed1846137bc9144fc6'
    default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2008 R2'

  end

end
