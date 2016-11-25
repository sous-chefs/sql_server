#
# Cookbook:: sql_server
# Spec:: server
#
# Copyright:: 2015-2016, Irving Popovetsky, All Rights Reserved.

require 'spec_helper'

describe 'sql_server::server' do
  context 'When all attributes are default, on Windows 2008R2, it should converge successfully' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2') do |node|
        node.normal['sql_server']['server_sa_password'] = 'supersecure'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'When all attributes are default, on Windows 2012, it should converge successfully' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
        node.normal['sql_server']['server_sa_password'] = 'supersecure'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'When specifying an Array of admin users for "sysadmins"' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012', file_cache_path: 'C:\chef\cache') do |node|
        node.normal['sql_server']['sysadmins'] = %w(Administrator Fred Barney)
        node.normal['sql_server']['server_sa_password'] = 'supersecure'
      end
      runner.converge(described_recipe)
    end

    it 'creates the correct ConfigurationFile.ini template' do
      expect(chef_run).to create_template('C:\chef\cache\ConfigurationFile.ini')
      expect(chef_run).to render_file('C:\chef\cache\ConfigurationFile.ini').with_content(/^SQLSYSADMINACCOUNTS="Administrator" "Fred" "Barney"/)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'When specifying a String for "sysadmins"' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012', file_cache_path: 'C:\chef\cache') do |node|
        node.normal['sql_server']['sysadmins'] = 'Administrator'
        node.normal['sql_server']['server_sa_password'] = 'supersecure'
      end
      runner.converge(described_recipe)
    end

    it 'creates the correct ConfigurationFile.ini template' do
      expect(chef_run).to create_template('C:\chef\cache\ConfigurationFile.ini')
      expect(chef_run).to render_file('C:\chef\cache\ConfigurationFile.ini').with_content(/^SQLSYSADMINACCOUNTS="Administrator"/)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
