system "
  apt-get update
"

# JDK & Git & cURL
%w{openjdk-6-jdk git build-essential libsqlite3-dev ruby1.9.3 ruby-bundler}.each do |p|
  package p do
    action :install
  end
end

execute "ruby1.9.3-default" do
  command "
    update-alternatives --install \"/usr/bin/ruby\" \"ruby\" \"/usr/bin/ruby1.9.1\" 400
    update-alternatives --set ruby /usr/bin/ruby1.9.1
    mkdir -p /var/lib/gems/1.9.1
  "
end
