execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
end

package 'python-software-properties' do
  action :install
end

execute "add-brightbox" do
  command "apt-add-repository -y ppa:brightbox/ruby-ng"
  ignore_failure true
  notifies :run, resources(:execute => "apt-get-update"), :immediately
  action :run
end

# JDK & Git & cURL & Ruby
%w{openjdk-6-jdk git build-essential libsqlite3-dev}.each do |p|
  package p do
    action :install
  end
end

execute "install-rake" do
  command "gem install rake"
  action :nothing
end

package 'ruby2.1' do
  action :install
  notifies :run, resources(:execute => "install-rake"), :immediately
end

package 'ruby-bundler' do
  action :install
end
