require 'spec_helper'

describe 'sql_server_configure' do
  platform 'windows', '2019'

  step_into :sql_server_configure

  context 'with default properties' do
    recipe do
      sql_server_configure 'SQLEXPRESS' do
        version '2019'
      end
    end

    it 'configures TCP settings' do
      expect(chef_run).to create_registry_key('HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL15.SQLEXPRESS\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll')
    end

    it 'configures Named Pipes settings' do
      expect(chef_run).to create_registry_key('HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL15.SQLEXPRESS\\MSSQLServer\\SuperSocketNetLib\\Np')
    end

    it 'configures Shared Memory settings' do
      expect(chef_run).to create_registry_key('HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL15.SQLEXPRESS\\MSSQLServer\\SuperSocketNetLib\\Sm')
    end

    it 'configures Via settings' do
      expect(chef_run).to create_registry_key('HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL15.SQLEXPRESS\\MSSQLServer\\SuperSocketNetLib\\Via')
    end

    it 'starts and enables the SQL Server service' do
      expect(chef_run).to start_service('MSSQL$SQLEXPRESS')
      expect(chef_run).to enable_service('MSSQL$SQLEXPRESS')
    end
  end

  context 'with MSSQLSERVER instance name' do
    recipe do
      sql_server_configure 'MSSQLSERVER' do
        version '2019'
      end
    end

    it 'uses the correct service name' do
      expect(chef_run).to start_service('MSSQLSERVER')
      expect(chef_run).to enable_service('MSSQLSERVER')
    end
  end

  context 'with agent_startup set to Automatic' do
    recipe do
      sql_server_configure 'SQLEXPRESS' do
        version '2019'
        agent_startup 'Automatic'
      end
    end

    it 'starts and enables the SQL Agent service' do
      expect(chef_run).to start_service('SQLAgent$SQLEXPRESS')
      expect(chef_run).to enable_service('SQLAgent$SQLEXPRESS')
    end
  end

  context 'with custom TCP port' do
    recipe do
      sql_server_configure 'SQLEXPRESS' do
        version '2019'
        sql_port 1434
      end
    end

    it 'configures the custom TCP port in registry' do
      expect(chef_run).to create_registry_key('HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL15.SQLEXPRESS\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll')
    end
  end
end
