require 'spec_helper'
require_relative '../../../libraries/helper'

describe SqlServer::Helper do
  describe '.reg_version_string' do
    it 'returns MSSQL13. for version 2016' do
      expect(described_class.reg_version_string('2016')).to eq('MSSQL13.')
    end

    it 'returns MSSQL14. for version 2017' do
      expect(described_class.reg_version_string('2017')).to eq('MSSQL14.')
    end

    it 'returns MSSQL15. for version 2019' do
      expect(described_class.reg_version_string('2019')).to eq('MSSQL15.')
    end

    it 'returns MSSQL16. for version 2022' do
      expect(described_class.reg_version_string('2022')).to eq('MSSQL16.')
    end

    it 'returns MSSQL17. for version 2025' do
      expect(described_class.reg_version_string('2025')).to eq('MSSQL17.')
    end

    it 'handles integer versions' do
      expect(described_class.reg_version_string(2019)).to eq('MSSQL15.')
    end

    it 'raises error for EOL version 2012' do
      expect { described_class.reg_version_string('2012') }.to raise_error(RuntimeError, /Supported versions/)
    end

    it 'raises error for unsupported version' do
      expect { described_class.reg_version_string('2010') }.to raise_error(RuntimeError, /Supported versions/)
    end
  end

  describe '.install_dir_version' do
    it 'returns 130 for version 2016' do
      expect(described_class.install_dir_version('2016')).to eq('130')
    end

    it 'returns 140 for version 2017' do
      expect(described_class.install_dir_version('2017')).to eq('140')
    end

    it 'returns 150 for version 2019' do
      expect(described_class.install_dir_version('2019')).to eq('150')
    end

    it 'returns 160 for version 2022' do
      expect(described_class.install_dir_version('2022')).to eq('160')
    end

    it 'returns 170 for version 2025' do
      expect(described_class.install_dir_version('2025')).to eq('170')
    end

    it 'raises error for EOL version 2012' do
      expect { described_class.install_dir_version('2012') }.to raise_error(RuntimeError, /Supported versions/)
    end

    it 'raises error for unsupported version' do
      expect { described_class.install_dir_version('2010') }.to raise_error(RuntimeError, /Supported versions/)
    end
  end

  describe '.sql_server_url' do
    context 'for x86_64 architecture' do
      it 'returns URL for version 2016' do
        expect(described_class.sql_server_url('2016', true)).to include('SQLEXPR_x64_ENU.exe')
      end

      it 'returns URL for version 2017' do
        expect(described_class.sql_server_url('2017', true)).to include('SQLEXPR_x64_ENU.exe')
      end

      it 'returns URL for version 2019' do
        expect(described_class.sql_server_url('2019', true)).to include('SQLEXPR_x64_ENU.exe')
      end

      it 'returns URL for version 2022' do
        expect(described_class.sql_server_url('2022', true)).to include('SQL2022-SSEI-Expr.exe')
      end

      it 'returns nil for version 2025 (URL not yet available)' do
        expect(described_class.sql_server_url('2025', true)).to be_nil
      end

      it 'returns nil for unsupported version' do
        expect(described_class.sql_server_url('2010', true)).to be_nil
      end
    end

    context 'for x86 architecture' do
      it 'returns nil for all versions (x86 not supported)' do
        expect(described_class.sql_server_url('2016', false)).to be_nil
        expect(described_class.sql_server_url('2019', false)).to be_nil
        expect(described_class.sql_server_url('2022', false)).to be_nil
      end
    end
  end

  describe '.sql_server_package_name' do
    context 'for x86_64 architecture' do
      it 'returns package name for version 2016' do
        expect(described_class.sql_server_package_name('2016', true)).to eq('Microsoft SQL Server 2016 (64-bit)')
      end

      it 'returns package name for version 2019' do
        expect(described_class.sql_server_package_name('2019', true)).to eq('Microsoft SQL Server 2019 (64-bit)')
      end

      it 'returns package name for version 2022' do
        expect(described_class.sql_server_package_name('2022', true)).to eq('Microsoft SQL Server 2022 (64-bit)')
      end

      it 'returns package name for version 2025' do
        expect(described_class.sql_server_package_name('2025', true)).to eq('Microsoft SQL Server 2025 (64-bit)')
      end

      it 'returns nil for unsupported version' do
        expect(described_class.sql_server_package_name('2010', true)).to be_nil
      end
    end

    context 'for x86 architecture' do
      it 'returns nil for all versions (x86 not supported)' do
        expect(described_class.sql_server_package_name('2019', false)).to be_nil
      end
    end
  end

  describe '.sql_server_checksum' do
    context 'for x86_64 architecture' do
      it 'returns checksum for version 2016' do
        expect(described_class.sql_server_checksum('2016', true)).to eq('2A5B64AE64A8285C024870EC4643617AC5146894DD59DD560E75CEA787BF9333')
      end

      it 'returns checksum for version 2022' do
        expect(described_class.sql_server_checksum('2022', true)).to eq('36e0ec2ac3dd60f496c99ce44722c629209ea7302a2ce9cbfd1e42a73510d7b6')
      end

      it 'returns nil for version 2025 (checksum not yet available)' do
        expect(described_class.sql_server_checksum('2025', true)).to be_nil
      end

      it 'returns nil for unsupported version' do
        expect(described_class.sql_server_checksum('2010', true)).to be_nil
      end
    end

    context 'for x86 architecture' do
      it 'returns nil for all versions (x86 not supported)' do
        expect(described_class.sql_server_checksum('2019', false)).to be_nil
      end
    end
  end
end
