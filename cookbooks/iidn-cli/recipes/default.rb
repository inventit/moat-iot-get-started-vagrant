project_home = "/home/#{node[:current][:user]}/iidn-cli"

execute "create project dir" do
  user node[:current][:user]
  command "mkdir -p #{project_home}"
end

execute "checkout" do
  user node[:current][:user]
  cwd project_home
  command "git clone git://github.com/inventit/iidn-cli.git ."
end

execute "add-path-bashrc" do
  user node[:current][:user]
  command "echo \"export PATH=#{project_home}:\\$PATH\" >> /home/#{node[:current][:user]}/.bashrc"
  not_if "grep iidn /home/#{node[:current][:user]}/.bashrc"
end

