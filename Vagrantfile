# Either 32 or 64 is available
ARCH = 32

# Set Proxy URL if your computer uses HTTP Proxy.
HTTP_PROXY = nil #"http://192.168.1.102:3128/"
HTTPS_PROXY = HTTP_PROXY
NO_PROXY = "localhost,127.0.0.1"

Vagrant.configure("2") do |config|
  chef_json = {}
  suffix = (ARCH == 32 ? '-i386' : '')
  config.vm.box = "opscode_ubuntu-12.04#{suffix}_chef-11.4.4"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04#{suffix}_chef-11.4.4.box"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
  end
  if HTTP_PROXY
    raise "install `vagrant-proxyconf` plugin prior to starting the image." unless Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http = HTTP_PROXY
    config.proxy.https = HTTPS_PROXY
    config.proxy.no_proxy = NO_PROXY

    require 'uri'
    http_proxy = URI(HTTP_PROXY)
    https_proxy = URI(HTTPS_PROXY)
    chef_json['maven'] = {
      'proxy' => {
        'http' => {
          'host' => http_proxy.host,
          'port' => http_proxy.port,
          'nonProxyHosts' => NO_PROXY
        },
        'https' => {
          'host' => https_proxy.host,
          'port' => https_proxy.port,
          'nonProxyHosts' => NO_PROXY
        }
      }
    }
    chef_json['nodejs'] = {
      'npm' => {
        'proxy' => {
          'http' => HTTP_PROXY,
          'https' => HTTPS_PROXY
        }
      }
    }
    config.vm.provision :shell, :inline => "
      echo '[http]' >> /etc/gitconfig
      echo '	proxy = #{HTTP_PROXY}' >> /etc/gitconfig
      echo '[https]' >> /etc/gitconfig
      echo '	proxy = #{HTTPS_PROXY}' >> /etc/gitconfig
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
