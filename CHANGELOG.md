# sql_server Cookbook CHANGELOG

This file is used to list changes made in each version of the sql_server cookbook.

## 5.1.0 (2016-12-20)

- Move server configuration in a new `sql_server::configure` recipe
- Add attributes to control network listeners via registry keys.

## 5.0.0 (2016-11-22)
- Avoid deprecation warnings with windows_package by using package instead. This requires Chef 12.6+ and Windows cookbook 2.0+
- Adding support for SQL Server Version 2014
- Default to SQL Server 2012
- Move a good chunk of the version logic to helpers instead of doing it in the recipes
- Use secure links to download older SQL express releases
- Add basic sql express 2016 support
- Don’t fail if the SQL version specified is an int and not a string
- Avoid blank lines if the optional configs aren’t passed

## 4.0.0 (2016-11-18)

- Remove relation between client & server recipes. This was not working correctly. You'll want to include both if you want client packages on your server now.
- Added Filestream Support
- Improved password escaping
- Remove SQL Server 2008 R2 / 2008 R2 SP1\. You must now be using 2008 R2 SP2+

## 3.0.0 (2016-09-07)

- Correct attribute to accept eula
- Require Chef 12+
- Testing updates

## v2.6.2(2016-05-17)

- README updates

## v2.6.1(2016-05-17)

- [PR #69](https://github.com/chef-cookbooks/sql_server/pull/69) Duplicate service restart
- Clean up rake file, maintainers toml/markdown

## v2.6.0(2016-05-17)

- [PR #59](https://github.com/chef-cookbooks/sql_server/pull/59) Support Named Instances
- [PR #61](https://github.com/chef-cookbooks/sql_server/pull/61) Restart Command For SQL Server
- [PR #67](https://github.com/chef-cookbooks/sql_server/pull/67) Updates for Standard Edition
- [PR #68](https://github.com/chef-cookbooks/sql_server/pull/68) Clarify remote install note

## v2.5.0(2016-02-12)

- Enable multiple sysadmin names.
- Removed the logic that auto generated node['sql_server']['server_sa_password'] and saved it to the node. The user will now need to set this to use the server recipe
- Removed the gem install of tiny_tds. This is not directly used by this cookbook. If you require this for the database cookbook you should install it in your own wrapper cookbook.
- Added support for SQL Server Client 2008 R2 SP2/SP2 and 2012 package installation
- Added the ability to specify the directories for system dbs, user dbs, logs, and tempdb in ConfigurationFile.ini
- Removed assumptions that C: is your system drive
- Added support SQL 2014 server in ConfigurationFile.ini
- Added the ability to pass account passwords to the installer vs. placing them in ConfigurationFile.ini
- Added ability to configure tempdb path, sqlbackupdir path, and sqlcollation in ConfigurationFile.ini
- Fixed computation of the reg_version and service_name variables
- Clarified the system and chef requirements in the readme
- Removed the Berksfile.lock
- Added Test Kitchen config with client and server suite
- Added updated contributing and testing docs
- Added Travis config
- Added Rakefile for simplified testing
- Added Rubocop config and resolved all warnings
- Added Gemfile with testing deps
- Added Maintainers files
- Added travis and cookbook version badges to the readme
- Added source_url and issues_url metadata for Supermarket

## v2.4.0 (2014-08-13)

- Fixing Checksums
- Changes to attribute interface

## v2.2.3 (2014-02-18)

- reverting OpenSSL module namespace change

## v2.2.2 (2014-02-17)

- updating to use the latest openssl

## v2.2.0 (2014-03-27)

- [COOK-4355] - Fix support for SQL server by using the right registry path

## v2.0.0 (2014-02-27)

[COOK-4253] - Make install options configurable

## v1.4.4 (2014-02-21)

### Improvement

- **[COOK-4268](https://tickets.chef.io/browse/COOK-4268)** - sql_server does not support installing SQL 2012

## v1.4.1 (2014-02-21)

### Improvement

- **[COOK-3892](https://tickets.chef.io/browse/COOK-3892)** - sql_server cookbook uses deprecated windows_registry LWRP

### Bug

- **[COOK-3725](https://tickets.chef.io/browse/COOK-3725)** - sql_server randomly-generated SA password sometimes not strong enough

## v1.3.0

### Improvement

- **[COOK-3507](https://tickets.chef.io/browse/COOK-3507)** - Broken SQLExpress download links...

### Bug

- **[COOK-3506](https://tickets.chef.io/browse/COOK-3506)** - SQLEXPRESS on 32 bits systems does not support INSTALLSHAREDWOWDIR
- **[COOK-3388](https://tickets.chef.io/browse/COOK-3388)** - Mixlib::ShellOut::CommandTimeout: command timed out error

## v1.2.2

- See (v1.2.1), made a mistake with DevOdd releases

## v1.2.1

### Improvement

- **[COOK-3088](https://tickets.chef.io/browse/COOK-3088)** - Allow setting feature_list

## v1.2.0

### Bug

- [COOK-3085]: Sql server configuration is incorrect when trying to install non-express version

## v1.1.0

- [COOK-1049] - remove unneeded external restart script from sql_server::server recipe

## v1.0.4

- bump windows cookbook dependency version to pick up Ruby 1.9 compat fixes

## v1.0.2

- [COOK-773] win_friendly_path is no longer a module_function
- rename accept_license_terms attribute to accept_eula for consistency with other cookbooks like iis

## v1.0.0

- [COOK-681] initial release
