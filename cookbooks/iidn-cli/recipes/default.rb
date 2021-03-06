project_home = "/home/#{node[:current][:user]}/iidn-cli"

execute "create iidn-cli dir" do
  user node[:current][:user]
  command "mkdir -p #{project_home}"
  not_if {File.exists?("#{project_home}")}
end

execute "checkout iidn-cli" do
  user node[:current][:user]
  cwd project_home
  command "git clone https://github.com/inventit/iidn-cli.git ."
  not_if {File.exists?("#{project_home}/iidn")}
end

execute "add iidn path to bashrc" do
  user node[:current][:user]
  command "echo \"export PATH=#{project_home}:\\$PATH\" >> /home/#{node[:current][:user]}/.bashrc"
  not_if "grep iidn /home/#{node[:current][:user]}/.bashrc"
end

execute "add CLI env" do
  user node[:current][:user]
  command "echo 'export CLI=#{project_home}' >> /home/#{node[:current][:user]}/.bashrc"
  not_if "grep CLI /home/#{node[:current][:user]}/.bashrc"
end