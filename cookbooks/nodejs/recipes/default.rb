%w{curl nodejs}.each do |p|
  package p do
    action :install
  end
end

execute "npm" do
  # clean=yes for avoiding /dev/tty error
  command "curl -k https://npmjs.org/install.sh | sudo clean=yes sh"
  not_if "which npm"
end

execute "nvm" do
  command "npm install -g nvm"
  not_if "which nvm"
end

execute "nodejs" do
  command "
    nvm download #{node[:nodejs][:version]}
    nvm build #{node[:nodejs][:version]}
    nvm install #{node[:nodejs][:version]}
  "
  not_if "node -v | grep #{node[:nodejs][:version]}"
end
