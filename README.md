# sql_server Cookbook

[![Travis Build Status](https://travis-ci.org/chef-cookbooks/sql_server.svg?branch=master)](http://travis-ci.org/chef-cookbooks/sql_server) [![Cookbook Version](https://img.shields.io/cookbook/v/sql_server.svg)](https://supermarket.chef.io/cookbooks/sql_server)[![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/ww3v5xdery9ha972/branch/master?svg=true)](https://ci.appveyor.com/project/ChefWindowsCookbooks/sql-server/branch/master)

Installs and configures Microsoft SQL Server 2008 R2 SP2 and Microsoft SQL Server 2012 server and client. By default the Express edition is installed, but the `sql_server::server` recipe supports installation of other editions (see **Usage** below).

## Requirements

### Platforms

- Windows Server 2008 R2 (SP2)
- Windows Server 2012 (R1, R2)

### Chef

- Chef 12.6+

### Cookbooks

- windows

## Attributes

### default

The following attributes are used by both client and server recipes.

- `node['sql_server']['accept_eula']` - indicate that you accept the terms of the end user license, default is 'false'
- `node['sql_server']['product_key']` - Specifies the product key for the edition of SQL Server, default is `nil` (not needed for SQL Server 2008 R2 Express installs)

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

## Usage

### default

Includes the `sql_server::client` recipe.

### client

Installs required the SQL Server Native Client and all required dependancies. These include:

- [Microsoft SQL Server 2008 R2 Native Client](http://www.microsoft.com/download/en/details.aspx?id=16978#SNAC)
- [Microsoft SQL Server 2008 R2 Command Line Utilities (ie `sqlcmd`)](http://www.microsoft.com/download/en/details.aspx?id=16978#SQLCMD)
- [Microsoft SQL Server System CLR Types](http://www.microsoft.com/download/en/details.aspx?id=16978#SQLSYSCLR)
- [Microsoft SQL Server 2008 R2 Management Objects](http://www.microsoft.com/download/en/details.aspx?id=16978#SMO)
- [Windows PowerShell Extensions for SQL Server 2008 R2](http://www.microsoft.com/download/en/details.aspx?id=16978#PowerShell)

The SQL Server Native Client contains the SQL Server ODBC driver and the SQL Server OLE DB provider in one native dynamic link library (DLL) supporting applications using native-code APIs (ODBC, OLE DB and ADO) to Microsoft SQL Server. In simple terms these packages should allow any other node to act as a client of a SQL Server instance.

### configure
Configures SQL Server registry keys via attributes, and restart the Engine service if required.

Current supported settings are mostly connection listeners:
- TCP or VIA listener ports
- TCP, Named Pipes, Shared Memory or VIA listener activation.

NOTE: It could be very dangerous to change these settings on a production server!

This recipe is included by the `sql_server::server` recipe, but can be included independently if you setup SQL Server by yourself.

### server

Installs SQL Server 2008 R2 Express or SQL Server 2012 Express.

By default, the cookbook installs SQL Server 2008 R2 Express. There are two options to install a different version.

NOTE: For this recipe to run you must set the node['sql_server']['server_sa_password'] in an environment, role, or wrapper cookbook.

NOTE: This recipe will request a reboot at the end of the Chef Client run if SQL Server was installed.. If you do not want to reboot after the installation, use the `reboot` resource to cancel the pending reboot.

**Option 1:** From a role, environment, or wrapper cookbook, set `node['sql_server']['version']` to '2008R2' to install SQL Server 2008 R2 Express, '2012' to install SQL Server 2012 Express or '2014' to install SQL Server 2014 Express.

**Option 2:** From a role, environment, or wrapper cookbook, set these node attributes to specify the URL, checksum, and name of the package (as it appears in the Windows Registry).

```
node['sql_server']['server']['url']
node['sql_server']['server']['checksum']
node['sql_server']['server']['package_name']
```

The installation is done using the `package` resource and [ConfigurationFile](http://msdn.microsoft.com/en-us/library/dd239405.aspx) generated from a `template` resource. The installation is slightly opinionated and does the following:

- Enables [Mixed Mode](http://msdn.microsoft.com/en-us/library/aa905171\(v=sql.80\).aspx) (Windows Authentication and SQL Server Authentication) authentication
- Auto-generates and sets a strong password for the 'sa' account
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

Out of the box this recipe installs the Express edition of SQL Server 2008 R2\. If you would like to install the Standard edition create a role as follows:

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

SQL Server does not support remote installation over WinRM. For example, the installation fails when you run `knife bootstrap windows winrm` or `knife winrm 'chef-client'` with a run-list that includes `server.rb`. However, you can use a scheduled task or run `chef-client` as a service. [Learn more](https://learn.chef.io/manage-a-web-app/windows/) in this Learn Chef tutorial.

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2011-2016, Chef Software, Inc.

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
