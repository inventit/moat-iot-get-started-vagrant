tarball = node[:maven][:tarball]
installation_dir = node[:maven][:installation_dir]
installation_dir_exists = File.exists?(installation_dir)

execute "wget" do
  cwd "/tmp"
  command "wget #{node[:maven][:tarball_url]}"
  creates "/tmp/#{tarball}"
  action :run
  not_if installation_dir_exists
end

execute "create installation_dir" do
  command "mkdir -p #{installation_dir}"
  not_if installation_dir_exists
end

remote_file "/tmp/#{tarball}" do
  source "#{node[:maven][:tarball_url]}"
  mode "0644"
  checksum "#{node[:maven][:tarball_checksum]}"
  not_if installation_dir_exists
end

execute "tar" do
  cwd installation_dir
  command "tar zxf /tmp/#{tarball}"
  action :run
  not_if installation_dir_exists
end

execute "chmod" do
  cwd installation_dir
  command "chmod 755 -R ."
  action :run
end

execute "add-maven-bashrc" do
  user node[:current][:user]
  path = "#{installation_dir}/#{node[:maven][:dirname]}/bin"
  command "echo \"export PATH=#{path}:\\$PATH\" >> /home/#{node[:current][:user]}/.bashrc"
  not_if "grep maven /home/#{node[:current][:user]}/.bashrc"
end
