name             'sql_server'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Installs/Configures Microsoft SQL Server 2008 R2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.5.0'
supports         'windows'
depends          'windows', '>= 1.2.6'

source_url 'https://github.com/chef-cookbooks/sql_server' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/sql_server/issues' if respond_to?(:issues_url)
