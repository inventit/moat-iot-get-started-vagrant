tarball = node[:android][:tarball]
installation_dir = node[:android][:installation_dir]
installation_dir_exists = File.exists?(installation_dir)

platform_dir = "#{installation_dir}/#{node[:android][:dirname]}/platforms/#{node[:android][:platform_android_version]}"

package 'ia32-libs' do
  action :install
  not_if "uname -a | grep i386"
end

execute "wget" do
  cwd "/tmp"
  command "wget #{node[:android][:tarball_url]}"
  creates "/tmp/#{tarball}"
  action :run
  not_if {installation_dir_exists}
end

execute "create installation_dir" do
  command "mkdir -p #{installation_dir}"
  not_if {installation_dir_exists}
end

remote_file "/tmp/#{tarball}" do
  source "#{node[:android][:tarball_url]}"
  mode "0644"
  checksum "#{node[:android][:tarball_checksum]}"
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

# Required as com.android.sdklib.SdkManager creates `build-tools` folder.
execute "chown" do
  cwd installation_dir
  command "chown -R #{node[:current][:user]} ."
  action :run
end

execute "add-android_home-bashrc" do
  user node[:current][:user]
  path = "#{installation_dir}/#{node[:android][:dirname]}"
  command "echo \"export ANDROID_HOME=#{path}\" >> /home/#{node[:current][:user]}/.bashrc"
  not_if "grep ANDROID_HOME /home/#{node[:current][:user]}/.bashrc"
end

execute "add-android-bashrc" do
  user node[:current][:user]
  command "echo \"export PATH=\\$ANDROID_HOME/platform-tools:\\$PATH\" >> /home/#{node[:current][:user]}/.bashrc"
  not_if "grep platform-tools /home/#{node[:current][:user]}/.bashrc"
end

execute "android update" do
  cwd "#{installation_dir}/#{node[:android][:dirname]}"
  command "#{installation_dir}/#{node[:android][:dirname]}/tools/android update sdk -u -t platform-tool"
  action :run
  not_if {File.exists?("#{installation_dir}/#{node[:android][:dirname]}/platform-tools")}
end

execute "wget platform" do
  cwd "/tmp"
  command "wget #{node[:android][:platform_url]}"
  creates "/tmp/#{node[:android][:platform_tarball]}"
  not_if {File.exists?(platform_dir)}
  action :run
end

remote_file "/tmp/#{node[:android][:platform_tarball]}" do
  source "#{node[:android][:platform_url]}"
  mode "0644"
  checksum "#{node[:android][:platform_tarball_checksum]}"
  not_if {File.exists?(platform_dir)}
end

execute "unzip platform" do
  cwd node[:android][:platform_dir]
  command "jar xf /tmp/#{node[:android][:platform_tarball]}"
  action :run
  not_if {File.exists?(platform_dir)}
end
