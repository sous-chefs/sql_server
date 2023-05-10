# sql_server Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/sql_server.svg)](https://supermarket.chef.io/cookbooks/sql_server)
[![CI
State](https://github.com/sous-chefs/sql_server/workflows/ci/badge.svg)](https://github.com/sous-chefs/sql_server/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides resources for the installation and configuration of Microsoft SQL Server server and client. Includes several basic recipes that utilize install and configure resources. See the usage section below for more information.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working
together to maintain important cookbooks. If you’d like to know more please visit
[sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in
[#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Windows Server 2012 (R1, R2)
- Windows Server 2016
- Windows Server 2019

### Supported Server Verions

- Microsoft SQL Server 2012
- Microsoft SQL Server 2016
- Microsoft SQL Server 2017
- Microsoft SQL Server 2019
- Microsoft SQL Server 2022

### Supported Client Versions

- Microsoft SQL Server 2012

### Chef

- Chef 13+

### Cookbooks

- windows

## Resources

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

- `version` - Version of SQL to be installed. Valid otpions are `2012`, `2016`, `2017`, `2019` or `2022`. Default is `2012`
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

### sql_server_configure

#### Actions

- `:service` - Configures the ports that SQL be listening on and starts and enables the SQL Service.

#### Properties

- `version` - SQL Version of the instance to be configured. Valid otpions are `2012`, `2016`, `2017` or `2019`. Default is `2012`
- `tcp_enabled` - If TCP is enabled for the instance. Default is true
- `sql_port` - Port SQL will listen on. Default is 1433
- `tcp_dynamic_ports` - Sets the Dynamic port SQL will listen on. Default is an empty string
- `np_enabled` - Whether named pipes is enabled. Default is false
- `sm_enabled` - Whether shared memory is enabled for the instance
- `via_default_port` - Configures the Virtual Interface Adapter default port. Default is `0:1433`
- `via_enabled` - Whether Virtual Interface Adapter is enabled. Default is false
- `via_listen_info` - Configures the Virtual interface listening information. Default is `0:1433`
- `agent_startup` - Configures the SQL Agent Service startup type. Valid options are `Automatic`, `Manual`, `Disabled`, or `Automatic (Delayed Start)`. Default is `Disabled`

#### Examples

Configure a SQL 2012 Express install with all the defaults

```ruby
sql_server_configure 'SQLEXPRESS'
```

Configure a SQL 2016 Express install

```ruby
sql_server_configure 'SQLEXPRESS' do
  version '2016'
end
```

Configure a SQL 2019 Express install

```ruby
sql_server_configure 'SQLEXPRESS' do
  version '2019'
end
```

Configure a SQL 2012 Evaluation install with a different port

```ruby
sql_server_configure 'MSSQLSERVER' do
  version '2012'
  sql_port '1434'
end
```

## Attributes

### default

The following attributes are used by both client and server recipes.

- `node['sql_server']['accept_eula']` - indicate that you accept the terms of the end user license, default is 'false'
- `node['sql_server']['product_key']` - Specifies the product key for the edition of SQL Server, default is `nil` (not needed for SQL Server Express installs)

### client

This file also contains download url, checksum and package name for all client installation packages. See the **Usage** section below for more details.

### server

- `node['sql_server']['install_dir']` - main directory for installation, default is `C:\Program Files\Microsoft SQL Server`
- `node['sql_server']['instance_name']` - name of the default instance, default is `SQLEXPRESS`
- `node['sql_server']['instance_dir']` - root directory of the default instance, default is `C:\Program Files\Microsoft SQL Server`
- `node['sql_server']['shared_wow_dir']` - root directory of the shared WOW directory, default is `C:\Program Files (x86)\Microsoft SQL Server`
- `node['sql_server']['agent_account']` - Agent account name, default is `NT AUTHORITY\NETWORK SERVICE`
- `node['sql_server']['agent_startup']` - Agent service startup mode, default is `Disabled`
- `node['sql_server']['rs_mode']` - Reporting Services install mode, default is `FilesOnlyMode`
- `node['sql_server']['rs_account']` - Reporting Services account name, default is `NT AUTHORITY\NETWORK SERVICE`
- `node['sql_server']['rs_startup']` - Reporting Services startup mode, default is `Automatic`
- `node['sql_server']['browser_startup']` - Browser Service startup mode, default is `Disabled`
- `node['sql_server']['sysadmins']` - Windows accounts that are SQL administrators, default is `Administrator`
- `node['sql_server']['sql_account']` - SQL service account name, default is `NT AUTHORITY\NETWORK SERVICE`

This file also contains download url, checksum and package name for the server installation package.

### configure

- `node['sql_server']['tcp_enabled']` - Enables TCP listener, default is `true`
- `node['sql_server']['port']` - Static TCP port server should listen on for client connections, default is `1433`
- `node['sql_server']['tcp_dynamic_ports']` - Dynamic TCP ports server should listen on for client connections, default is `''`
- `node['sql_server']['np_enabled']` - Enables Named pipes listener, default is `false`
- `node['sql_server']['sm_enabled']` - Enables Shared Memory listener, default is `true`
- `node['sql_server']['via_default_port']` - VIA default listener port, default is `0:1433`
- `node['sql_server']['via_enabled']` - Enables VIA listener, default is `false`
- `node['sql_server']['via_listen_info']` - VIA listener info, default is `0:1433`

## Recipe Usage

We highly recommend writing your own wrapper cookbook utilizing the above resources, but this cookbook also ships with legacy recipes that can be used to install sql_server using recipes/attributes.

### default

Includes the `sql_server::client` recipe.

### client

Installs required the SQL Server Native Client and all required dependencies. The SQL Server Native Client contains the SQL Server ODBC driver and the SQL Server OLE DB provider in one native dynamic link library (DLL) supporting applications using native-code APIs (ODBC, OLE DB and ADO) to Microsoft SQL Server. In simple terms these packages should allow any other node to act as a client of a SQL Server instance.

### configure

Configures SQL Server registry keys via attributes, and restart the Engine service if required.

Current supported settings are mostly connection listeners:

- TCP or VIA listener ports
- TCP, Named Pipes, Shared Memory or VIA listener activation.

NOTE: It could be very dangerous to change these settings on a production server!

This recipe is included by the `sql_server::server` recipe, but can be included independently if you setup SQL Server by yourself.

### server

Installs SQL Server 2012 Express, SQL Server 2016 Express, or SQL Server 2019 Express.

By default, the cookbook installs SQL Server 2012 Express. There are two options to install a different version.

NOTE: For this recipe to run you must set the following attributes in an environment, role, or wrapper cookbook.

```ruby
node['sql_server']['agent_account_pwd']
node['sql_server']['rs_account_pwd']
node['sql_server']['sql_account_pwd']
```

NOTE: This recipe will request a reboot at the end of the Chef Client run if SQL Server was installed.. If you do not want to reboot after the installation, use the `reboot` resource to cancel the pending reboot.

**Option 1:** From a role, environment, or wrapper cookbook, set `node['sql_server']['version']` to '2012' to install SQL Server 2012 Express, or '2016' to install SQL Server 2016 Express.

**Option 2:** From a role, environment, or wrapper cookbook, set these node attributes to specify the URL, checksum, and name of the package (as it appears in the Windows Registry).

```ruby
node['sql_server']['server']['url']
node['sql_server']['server']['checksum']
node['sql_server']['server']['package_name']
```

The installation is done using the `package` resource and [ConfigurationFile](http://msdn.microsoft.com/en-us/library/dd239405.aspx) generated from a `template` resource. The installation is slightly opinionated and does the following:

- Enables [Mixed Mode](http://msdn.microsoft.com/en-us/library/aa905171\(v=sql.80\).aspx) (Windows Authentication and SQL Server Authentication) authentication
- sets a static TCP port which is configurable via an attribute, using the `sql_server::configure` recipe.

Installing any of the SQL Server server or client packages in an unattended/automated way requires you to explicitly indicate that you accept the terms of the end user license. The hooks have been added to all recipes to do this via an attribute. Create a role to set the `node['sql_server']['accept_eula']` attribute to 'true'. For example:

```ruby
name "sql_server"
description "SQL Server database master"
run_list(
  "recipe[sql_server::server]"
)
default_attributes(
  "sql_server" => {
    "accept_eula" => true
  }
)
```

Out of the box this recipe installs the Express edition of SQL Server 2012\. If you would like to install the Standard edition create a role as follows:

```ruby
name "sql_server_standard"
description "SQL Server Stadard edition database master"
run_list(
  "recipe[sql_server::server]"
)
default_attributes(
  "sql_server" => {
    "instance_name" => "MSSQLSERVER",
    "product_key" => "YOUR_PRODUCT_KEY_HERE",
    "accept_eula" => true,
    "server" => {
      "url" => "DOWNLOAD_LOCATION_OF_INSTALLATION_PACKAGE",
      "checksum" => "SHA256_OF_INSTALLATION_PACKAGE"
    }
  }
)
```

Depending on your base Windows installation you may also need to open the configured static port in the Windows Firewall. In the name of security we do not do this by default but the follow code should get the job done:

```ruby
# unlock port in firewall
# this should leverage firewall_rule resource
# once COOK-689 is completed
firewall_rule_name = "#{node['sql_server']['instance_name']} Static Port"

execute "open-static-port" do
  command "netsh advfirewall firewall add rule name=\"#{firewall_rule_name}\" dir=in action=allow protocol=TCP localport=#{node['sql_server']['port']}"
  returns [0,1,42] # *sigh* cmd.exe return codes are wonky
  not_if { SqlServer::Helper.firewall_rule_enabled?(firewall_rule_name) }
end
```

## Installing SQL Server remotely

SQL Server does not support remote installation over WinRM. For example, the installation fails when you run `knife bootstrap windows winrm` or `knife winrm 'chef-client'` with a run-list that includes `server.rb`. However, you can use a scheduled task or run `chef-client` as a service.

## Contributors

This project exists thanks to all the people who
[contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
