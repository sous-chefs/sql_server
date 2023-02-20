
### sql_server_install

#### Actions

- `:install` - Installs the version of Microsoft SQL server specified. Default install is SQL 2012 Express.

#### Properties

- `feature` - An Array of the SQL Instance or Server features that are going to be enabled / installed.
  - [SQL 2012 Available Features list](https://technet.microsoft.com/library/cc645993(SQL.110).aspx)
    - Instance Features
      - `SQLENGINE` = Database Engine
      - `REPLICATION` = Replication
      - `FULLTEXT` = Full-Text and Semantic Extractions for search
      - `DQ` = Data Quality Services
      - `AS` = Analysis Services
      - `RS` = Reporting Services - Native
    - Shared Features
      - `RS_SHP` = Reporting Services - SharePoint
      - `RS_SHPWFE` = Reporting Services Add-in for SharePoint Products
      - `DQC` = Data Quality Client
      - `BIDS` = SQL Server data tools
      - `CONN` = Client tools connectivity
      - `IS` = Integration Services
      - `BC` = Client tools backwards compatibility
      - `SDK` = Client tools SDK
      - `BOL` = Documentation components
      - `SSMS` = Management tools
      - `SSMS_ADV` = Management tools - Advanced
      - `DREPLAY_CTLR` = Distributed replay controller
      - `DREPLAY_CLT` = Distributed replay client
      - `SNAC_SDK` = SQL client connectivity SDK
  - [SQL 2016 Available Features list](https://technet.microsoft.com/library/cc645993(SQL.130).aspx)
    - Instance Features
      - `ADVANCEDANALYTICS` = R Services (In-Database)
      - `POLYBASE` = PolyBase Query Service for External Data
           Note: This Feature Requires Java Runtime Environment greater than 7 update 51. Only the standalone Polybase-enabled Instance is currently support by this cookbook.
    - Shared Features
      - `SQL_SHARED_MR` = R Server (Standalone)
      - `MDS` = Master Data Services
      - REMOVED for standalone install
        - `SSMS` = Management tools
        - `SSMS_ADV` = Management tools - Advanced
  - [SQL 2017 Available Features list](https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2017)
    - Instance Features
      - `ADVANCEDANALYTICS` = Machine Learning services (In-Database)
        - `SQL_INST_MPY` = Machine Learning services (In-Database) with Python
        - `SQL_INST_MR` = Machine Learning services (In-Database) with R
    - Shared Features
      - `SQL_SHARED_AA` = Machine Learning Services (Standalone)
        - `SQL_SHARED_MR` = Machine Learning services (In-Database) with R
        - `SQL_SHARED_MPY` = Machine Learning services (In-Database) with Python
      - `IS` = Integrated Services
        - `IS_MASTER` - Scale Out Master
        - `IS_WORKER` - Scale Out Worker

- `version` - Version of SQL to be installed. Valid otpions are `2012`, `2016`, or `2017`. Default is `2012`
- `source_url` - Source of the SQL setup.exe install file. Default is built from the helper libraries.
- `package_name` - Package name for the SQL install. If you specify a version this property is not necessary. Default is built from the helper libraries.
- `package_checksum` - Package checksum in SHA256 format for the setup.exe file. Default is built from the helper libraries.
- `sql_reboot` - Determines whether the node will be rebooted after the SQL Server installation. Default setting is true
- `security_mode` - The Autentication mode for SQL. Valid options are `Windows Athentication` or `Mixed Mode Authentication`. Default value is `Windows Authentication`
- `sa_password` - The SQL Administrator password when `Mixed Mode Authentication` is being used. SQL enforces a strong passwords for this value.
- `sysadmins` - The list of Systems Administrators who can access the SQL Instance. This can either be a String or an Array.
- `agent_account` - The Service Account that will be used to run the SQL Agent Service. Default is `NT AUTHORITY\SYSTEM`.
- `agent_startup` - The Agent Service startup type. Valid options are `Automatic`, `Manual`, `Disabled`, or `Automatic (Delayed Start)`. Default is `Disabled`.
- `agent_account_pwd` - Agent Service Account password.
- `sql_account` - Service Account used to run the SQL service. Default is `NT AUTHORITY\NETWORK SERVICE`
- `sql_account_pwd` - Service Account password for the SQL service account.
- `browser_startup` - Service startup type for the SQL Browser Service. Valid options are `Automatic`, `Manual`, `Disabled`, or `Automatic (Delayed Start)`. Default is `Disabled`.
- `installer_timeout` - Time out for the SQL installation. Default is `1500`
- `accept_eula` - Whether or not to accept the end user license agreement. Default is `false`
   Note: For SQL 2016 if this will also accept the license for using R if `ADVANCEDANALYTICS` or `SQL_SHARED_MR` is listed in the feature property array.
- `product_key` - Product key for not Express or Evaluation versions.
- `update_enabled` - Whether or not to download updates during install. Default is true.
- `update_source` - The Source Location of Windows Update or WSUS. Default is `MU`. Example = `c:/path/to/update`
- `instance_name` - Name for the instance to be installed. Default is `SQLEXPRESS`. For non-express installs that want the default install it should be set to `MSSQLSERVER`.
- `install_dir` - Directory SQL binaries will be installed to. Default is `C:\Program Files\Microsoft SQL Server`
- `instance_dir` - Directory the Instance will be stored. Default is `C:\Program Files\Microsoft SQL Server`
- `sql_data_dir` - Directory for SQL data
- `sql_backup_dir` - Directory for backups
- `sql_instant_file_init` - Enable instant file initialization for SQL Server service account. Default is `false`
- `sql_user_db_dir` - Directory for the user database
- `sql_user_db_log_dir`  - Directory for the user database logs
- `sql_temp_db_dir` - Directory for the temporary database
- `sql_temp_db_log_dir` - Directory for the temporary database logs
- `sql_temp_db_file_count` - Number of TempDB data files. Default is 8 or number of cores, whichever is lower.
- `sql_temp_db_file_size` - Initial size of each TempDB data file in MB. Default is 8.
- `sql_temp_db_file_growth` - Automatic growth increment for each TempDB data file in MB. Default is 64.
- `sql_temp_db_log_file_size` - Initial size of the TempDB log file in MB. Default is 8.
- `sql_temp_db_log_file_growth` - Automatic growth increment for the TempDB log file in MB. Default is 64.
- `filestream_level` - Level to enable the filestream feature, Valid values are 0, 1, 2 or 3. Default is 0
- `filestream_share_name` - Share name for the filestream feature. Default is `MSSQLSERVER`
- `sql_collation` - SQL Collation type for the instance
- `netfx35_install` - If the .Net 3.5 Windows Feature is installed. This is required to successfully install SQL 2012. Default is true.
- `netfx35_source` - Source location for the .Net 3.5 Windows Features install. Only required for offline installs

Distributed Replay

- `dreplay_ctlr_admins` - List of admins for the Distributed Replay Controller. Default is `Administrator`. The `DREPLAY_CTLR` feature needs to be included in the feature Array for this property to work.
- `dreplay_client_name` - Host name of the Distributed Replay Controller that the Client will point to. If the `DREPLAY_CLT` is in the feature list this property needs to be set.

Reporting Services

- `rs_account` - Service Account name used to run SQL Reporting Services. To have reporting services it needs to be listed in the `feature` property array.
- `rs_account_pwd` - Service Account password for the Reporting Services Service
- `rs_startup` - Reporting Services service startup type. Valid options are `Automatic`, `Manual`, `Disabled`, or `Automatic (Delayed Start)`. Default is `Automatic`.
- `rs_mode` - Mode the Reporting Services is installed in. Default is `FilesOnlyMode`

Analysis Services

- `as_sysadmins` - Analysis Services Systems Administrator list. Default is `Administrator`
- `as_svc_account` - Service Account used by Analysis Services. Default is `NT Service\MSSQLServerOLAPService`

PolyBase Query Services

- `polybase_port_range` - Port Range for the PolyBase Query Service. Default is `16450-16460`.

Integrated Services

- `is_master_port` - Port for the Integrated Services Scale out Master. Default is 8391.
- `is_master_ssl_cert` - The CNs in the certificate used to protect communications between the integration services scale out worker and scale out master.
- `is_master_cert_thumbprint` - The certificate thumbprint for the scale out master ssl certificate.
- `is_worker_master_url` - The url of the scale out master when installing a scale out worker.

#### Examples

Install SQL 2012 Express with all the defaults

```ruby
sql_server_install 'Install SQL 2012 Express'
```

Install SQL 2016 Express

```ruby
sql_server_install 'Install SQL 2016 Express' do
  version '2016'
end
```

Install SQL 2012 Evaluation from a local source with default instance name, Integrated Services, Reporting Services, and the SQL Management Tools.

```ruby
sql_server_install 'Install SQL Server 2012 Evaluation' do
  source_url 'C:\\Sources\\SQL 2012 Eval\\setup.exe'
  version '2012'
  package_checksum '0FE903...420E8F'
  accept_eula true
  instance_name 'MSSQLSERVER'
  feature %w(SQLENGINE IS RS SSMS ADV_SSMS)
end
```
