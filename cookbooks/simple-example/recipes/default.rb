project_home = "/home/#{node[:current][:user]}/moat-iot-get-started"

execute "create project dir" do
  user node[:current][:user]
  command "mkdir -p #{project_home}"
end

execute "checkout moat-iot-get-started" do
  user node[:current][:user]
  cwd project_home
  command "git clone git://github.com/inventit/moat-iot-get-started.git ."
end

execute "add APP env" do
  user node[:current][:user]
  command "echo 'export APP=#{project_home}' >> /home/#{node[:current][:user]}/.bashrc"
  not_if "grep APP /home/#{node[:current][:user]}/.bashrc"
end