# Either 32 or 64 is available
ARCH = 32

# Set Proxy URL if your computer uses HTTP Proxy.
PROXY_URL = nil #"http://192.168.1.101:3128/"

Vagrant.configure("2") do |config|
  chef_json = {}
  suffix = (ARCH == 32 ? '-i386' : '')
  config.vm.box = "opscode_ubuntu-12.04#{suffix}_chef-11.4.4"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04#{suffix}_chef-11.4.4.box"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
  end
  if PROXY_URL
    require 'uri'
    proxy = URI(PROXY_URL)
    chef_json['maven'] = {
      'proxy' => {
        'http' => {
          'host' => proxy.host,
          'port' => proxy.port,
          'nonProxyHosts' => 'localhost,127.0.0.1'
        },
        'https' => {
          'host' => proxy.host,
          'port' => proxy.port,
          'nonProxyHosts' => 'localhost,127.0.0.1'
        }
      }
    }
    config.vm.provision :shell, :inline => "
      echo 'Acquire::http::proxy \"#{PROXY_URL}\";' >> /etc/apt/apt.conf
      echo 'Acquire::https::proxy \"#{PROXY_URL}\";' >> /etc/apt/apt.conf
      echo 'http_proxy=\"#{PROXY_URL}\"' >> /etc/environment
      echo 'https_proxy=\"#{PROXY_URL}\"' >> /etc/environment
      echo 'no_proxy=\"localhost,127.0.0.1\"' >> /etc/environment
      echo 'HTTP_PROXY=\"#{PROXY_URL}\"' >> /etc/environment
      echo 'HTTPS_PROXY=\"#{PROXY_URL}\"' >> /etc/environment
      echo 'NO_PROXY=\"localhost,127.0.0.1\"' >> /etc/environment
      echo '[http]' >> /etc/gitconfig
      echo '	proxy = #{PROXY_URL}' >> /etc/gitconfig
    "
  end
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe("ubuntu")
    chef.add_recipe("nodejs")
    chef.add_recipe("maven")
    chef.add_recipe("android-sdk")
    chef.add_recipe("iidn-cli")
    chef.add_recipe("simple-example")
    chef.json = chef_json
  end
  # Forward guest port 3000 to host port 3000
  config.vm.network :forwarded_port, guest: 3000, host: 3000
end
