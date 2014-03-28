sql_server Cookbook CHANGELOG
=============================
This file is used to list changes made in each version of the sql_server cookbook.


v2.2.0 (2014-03-27)
-------------------
- [COOK-4355] - Fix support for SQL server by using the right registry path


v2.0.0 (2014-02-27)
-------------------
[COOK-4253] - Make install options configurable


v1.4.4 (2014-02-21)
-------------------
### Improvement
- **[COOK-4268](https://tickets.opscode.com/browse/COOK-4268)** - sql_server does not support installing SQL 2012


v1.4.1 (2014-02-21)
-------------------
### Improvement
- **[COOK-3892](https://tickets.opscode.com/browse/COOK-3892)** - sql_server cookbook uses deprecated windows_registry LWRP

### Bug
- **[COOK-3725](https://tickets.opscode.com/browse/COOK-3725)** - sql_server randomly-generated SA password sometimes not strong enough


v1.3.0
------
### Improvement
- **[COOK-3507](https://tickets.opscode.com/browse/COOK-3507)** - Broken SQLExpress download links...

### Bug
- **[COOK-3506](https://tickets.opscode.com/browse/COOK-3506)** - SQLEXPRESS on 32 bits systems does not support INSTALLSHAREDWOWDIR
- **[COOK-3388](https://tickets.opscode.com/browse/COOK-3388)** - Mixlib::ShellOut::CommandTimeout: command timed out error


v1.2.2
------
- See (v1.2.1), made a mistake with DevOdd releases

v1.2.1
------
### Improvement
- **[COOK-3088](https://tickets.opscode.com/browse/COOK-3088)** - Allow setting feature_list

v1.2.0
------
### Bug
- [COOK-3085]: Sql server configuration is incorrect when trying to install non-express version

v1.1.0
------
- [COOK-1049] - remove unneeded external restart script from sql_server::server recipe

v1.0.4
------
- bump windows cookbook dependency version to pick up Ruby 1.9 compat fixes

v1.0.2
------
- [COOK-773] win_friendly_path is no longer a module_function
- rename accept_license_terms attribute to accept_eula for consistency with other cookbooks like iis

v1.0.0
------
- [COOK-681] initial release
