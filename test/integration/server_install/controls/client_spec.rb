control 'client' do
  [
    'Microsoft SQL Server 2012 Command Line Utilities ',
    'Microsoft SQL Server 2012 Management Objects  (x64)',
    'Microsoft SQL Server 2012 Native Client ',
    'Microsoft System CLR Types for SQL Server 2012 (x64)',
    'Windows PowerShell Extensions for SQL Server 2012 ',
  ].each do |msql_pkg|
    describe package(msql_pkg) do
      it { should be_installed }
      its('version') { should eq '11.0.2100.60' }
    end
  end

  describe command 'sqlcmd -?' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /SQL Server Command Line Tool/ }
  end
end
