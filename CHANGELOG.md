sql_server Cookbook CHANGELOG
=============================
This file is used to list changes made in each version of the sql_server cookbook.


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
