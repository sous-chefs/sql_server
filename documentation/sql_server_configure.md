# sql_server_configure

## Actions

- `:service` - Configures the ports that SQL be listening on and starts and enables the SQL Service.

## Properties

- `version` - SQL Version of the instance to be configured. Valid options are `2012`, `2016`, `2017`, `2019`, `2022`, `2025`. Default is `2012`
- `tcp_enabled` - If TCP is enabled for the instance. Default is true
- `sql_port` - Port SQL will listen on. Default is 1433
- `tcp_dynamic_ports` - Sets the Dynamic port SQL will listen on. Default is an empty string
- `np_enabled` - Whether named pipes is enabled. Default is false
- `sm_enabled` - Whether shared memory is enabled for the instance
- `via_default_port` - Configures the Virtual Interface Adapter default port. Default is `0:1433`
- `via_enabled` - Whether Virtual Interface Adapter is enabled. Default is false
- `via_listen_info` - Configures the Virtual interface listening information. Default is `0:1433`
- `agent_startup` - Configures the SQL Agent Service startup type. Valid options are `Automatic`, `Manual`, `Disabled`, or `Automatic (Delayed Start)`. Default is `Disabled`

## Examples

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
