unified_mode true

property :native_client,
        Hash,
        default: {
          url: 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/sqlncli.msi',
          checksum: '5601a1969d12a72a16e3659712bc9727b3fd874b5f6f802fd1e042cac75cc069',
          package_name: 'Microsoft SQL Server 2012 Native Client',
        }

property :command_line_utils,
        Hash,
        default: {
          url: 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SqlCmdLnUtils.msi',
          checksum: '3f5cb4b876421286f8fd9666f00345a95d8ce1b6229baa6aeb2f076ef9e4aefe',
          package_name: 'Microsoft SQL Server 2012 Command Line Utilities',
        }

property :clr_types,
        Hash,
        default: {
          url: 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SQLSysClrTypes.msi',
          checksum: '4b2f86c3f001d6a13db25bf993f8144430db04bde43853b9f2e359aa4bd491d0',
          package_name: 'Microsoft SQL Server System CLR Types (x64)',
        }

property :smo,
        Hash,
        default: {
          url: 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SharedManagementObjects.msi',
          checksum: '36d174cd87d5fc432beb4861863d8a7f944b812032727a6e7074a1fcab950faa',
          package_name: 'Microsoft SQL Server 2012 Management Objects (x64)',
        }

property :ps_extensions,
        Hash,
        default: {
          url: 'http://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/PowerShellTools.MSI',
          checksum: 'bb33e64659f7500d7f2088e3d5e7ac34a1bf13988736b8ba0075741fce1e67b6',
          package_name: 'Windows PowerShell Extensions for SQL Server 2012',
        }

property :accept_eula, [true, false], default: false

action :install do
  %w( native_client command_line_utils clr_types smo ps_extensions ).each do |_pkg|
    package new_resource.pkg do
      source new_resource.pkg[:source]
      url new_resource.pkg[:url]
      checksum new_resource.pkg[:checksum]
      installer_type :msi
      options "IACCEPTSQLNCLILICENSETERMS=#{new_resource.accept_eula ? 'YES' : 'NO'}"
      action :install
    end
  end
end
