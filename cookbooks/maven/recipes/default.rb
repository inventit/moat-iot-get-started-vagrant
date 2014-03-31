tarball = node[:maven][:tarball]
installation_dir = node[:maven][:installation_dir]
installation_dir_exists = File.exists?(installation_dir)

execute "wget" do
  cwd "/tmp"
  command "wget #{node[:maven][:tarball_url]}"
  creates "/tmp/#{tarball}"
  action :run
  not_if {installation_dir_exists}
end

execute "create installation_dir" do
  command "mkdir -p #{installation_dir}"
  not_if {installation_dir_exists}
end

remote_file "/tmp/#{tarball}" do
  source "#{node[:maven][:tarball_url]}"
  mode "0644"
  checksum "#{node[:maven][:tarball_checksum]}"
  not_if {installation_dir_exists}
end

execute "tar" do
  cwd installation_dir
  command "tar zxf /tmp/#{tarball}"
  action :run
  not_if {installation_dir_exists}
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

# create directory
m2_user_dir = "/home/#{node[:current][:user]}/.m2"
execute "mkdir #{m2_user_dir}" do
  user node[:current][:user]
  group node[:current][:user]
  command <<-CMD
    mkdir -p #{m2_user_dir}
  CMD
  not_if {File.exists?("#{m2_user_dir}")}
end

template "#{m2_user_dir}/settings.xml" do
  user node[:current][:user]
  group node[:current][:user]
  source "settings.xml.erb"
  mappings = {}
  if node['maven']['proxy']
    proxy = node['maven']['proxy']
    http = proxy['http']
    https = proxy['https']
    if http
      mappings.merge!({
        :http_proxy_host => http['host'],
        :http_proxy_port => http['port'],
        :http_proxy_nonProxyHosts => http['nonProxyHosts'],
        })
    end
    if https
      mappings.merge!({
        :https_proxy_host => https['host'],
        :https_proxy_port => https['port'],
        :https_proxy_nonProxyHosts => http['nonProxyHosts'],
        })
    end
  end
  variables(mappings)
end
