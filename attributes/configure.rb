#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: sql_server
# Attribute:: configure
#
# Copyright:: Copyright (c) 2011-2016 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Tcp settings
default['sql_server']['tcp_enabled']       = true
default['sql_server']['port']              = 1433 # Keep port for backward compatibility
default['sql_server']['tcp_dynamic_ports'] = ''
# Named Pipes settings
default['sql_server']['np_enabled']        = false
# Shared Memory settings
default['sql_server']['sm_enabled']        = true
# Via settings
default['sql_server']['via_default_port']  = '0:1433'
default['sql_server']['via_enabled']       = false
default['sql_server']['via_listen_info']   = '0:1433'
