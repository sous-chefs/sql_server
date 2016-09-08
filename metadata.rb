name             'sql_server'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Installs/Configures Microsoft SQL Server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.6.2'
supports         'windows'
depends          'windows', '>= 1.2.6'

source_url 'https://github.com/chef-cookbooks/sql_server'
issues_url 'https://github.com/chef-cookbooks/sql_server/issues'
chef_version     '>= 12.1'
