require 'spec_helper'

describe 'sql_server_install' do
  platform 'windows', '2019'

  step_into :sql_server_install

  default_attributes['kernel'] = { 'machine' => 'x86_64' }

  context 'with default properties on x86_64' do
    recipe do
      sql_server_install 'Install SQL Server' do
        accept_eula true
        sa_password 'Supersecurepassword123'
      end
    end

    it 'creates the configuration file template' do
      expect(chef_run).to create_template(/ConfigurationFile\.ini/)
    end

    it 'installs the SQL Server package' do
      expect(chef_run).to install_package('Microsoft SQL Server 2022 (64-bit)')
    end

    it 'creates a reboot resource' do
      expect(chef_run).to nothing_reboot('sql server install')
    end
  end

  context 'with version 2019' do
    recipe do
      sql_server_install 'Install SQL Server 2019' do
        accept_eula true
        sa_password 'Supersecurepassword123'
        version '2019'
      end
    end

    it 'installs the SQL Server 2019 package' do
      expect(chef_run).to install_package('Microsoft SQL Server 2019 (64-bit)')
    end
  end

  context 'with Mixed Mode Authentication' do
    recipe do
      sql_server_install 'Install SQL Server Mixed Mode' do
        accept_eula true
        security_mode 'Mixed Mode Authentication'
        sa_password 'Supersecurepassword123'
      end
    end

    it 'creates the configuration file' do
      expect(chef_run).to create_template(/ConfigurationFile\.ini/)
    end
  end

  context 'with netfx35_install enabled' do
    recipe do
      sql_server_install 'Install SQL Server with .NET 3.5' do
        accept_eula true
        sa_password 'Supersecurepassword123'
        netfx35_install true
      end
    end

    it 'installs the .NET Framework features' do
      expect(chef_run).to install_windows_feature('NET-Framework-Features, NET-Framework-Core')
    end
  end

  context 'with custom source_url' do
    recipe do
      sql_server_install 'Install SQL Server Custom' do
        accept_eula true
        sa_password 'Supersecurepassword123'
        version '2025'
        source_url 'https://example.com/sql2025.exe'
        package_name 'Microsoft SQL Server 2025 (64-bit)'
        package_checksum 'abc123'
      end
    end

    it 'installs the custom SQL Server package' do
      expect(chef_run).to install_package('Microsoft SQL Server 2025 (64-bit)')
    end
  end
end
