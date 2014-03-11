%w{curl git}.each do |p|
  package p do
    action :install
  end
end

execute "nvm" do
  user node[:current][:user]
  command "
    HOME=/home/#{node[:current][:user]} && curl https://raw.github.com/creationix/nvm/master/install.sh | sh
  "
  not_if "grep nvm /home/#{node[:current][:user]}/.profile"
end

bash "nodejs" do
  user node[:current][:user]
  code "
    HOME=/home/#{node[:current][:user]} . /home/#{node[:current][:user]}/.profile
    nvm install #{node[:nodejs][:version]}
    nvm alias default #{node[:nodejs][:version]}
  "
  not_if "HOME=/home/#{node[:current][:user]} && . $HOME/.profile && node -v | grep #{node[:nodejs][:version]}"
end

bash "npm" do
  user node[:current][:user]
  cwd "/tmp"
  # clean=yes for avoiding /dev/tty error
  code "
    HOME=/home/#{node[:current][:user]} . /home/#{node[:current][:user]}/.profile
    HOME=/home/#{node[:current][:user]} && curl -k https://npmjs.org/install.sh | clean=yes sh
  "
  not_if {File.exists?("/home/#{node[:current][:user]}/.nvm/v#{node[:nodejs][:version]}/bin/npm")}
end

bash "npm install moat" do
  user node[:current][:user]
  code "
    HOME=/home/#{node[:current][:user]} . /home/#{node[:current][:user]}/.profile
    HOME=/home/#{node[:current][:user]} && npm install -g moat
  "
  not_if {File.exists?("/home/#{node[:current][:user]}/.npm/moat")}
end

bash "npm install nodeunit" do
  user node[:current][:user]
  code "
    HOME=/home/#{node[:current][:user]} . /home/#{node[:current][:user]}/.profile
    HOME=/home/#{node[:current][:user]} && npm install -g nodeunit
  "
  not_if {File.exists?("/home/#{node[:current][:user]}/.npm/nodeunit")}
end

bash "npm install sinon" do
  user node[:current][:user]
  code "
    HOME=/home/#{node[:current][:user]} . /home/#{node[:current][:user]}/.profile
    HOME=/home/#{node[:current][:user]} && npm install -g sinon
  "
  not_if {File.exists?("/home/#{node[:current][:user]}/.npm/sinon")}
end
