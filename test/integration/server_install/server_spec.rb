version = input('version')

control 'server' do
  describe package("Microsoft SQL Server #{version} (64-bit)") do
    it { should be_installed }
  end

  describe service('MSSQL$SQLEXPRESS') do
    it { should be_installed }
    it { should be_running }
  end

  describe service('SQLAgent$SQLEXPRESS') do
    it { should be_installed }
  end

  describe port(1433) do
    it { should be_listening }
  end
end
