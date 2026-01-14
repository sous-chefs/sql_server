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
- Microsoft SQL Server 2025

### Supported Client Versions

- Microsoft SQL Server 2012

### Chef

- Chef 15.3+

## Resources

- [sql_server_install](documentation/sql_server_install.md)
- [sql_server_configure](documentation/sql_server_configure.md)

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
