# Either 32 or 64 is available
ARCH = 32

Vagrant.configure("2") do |config|
  suffix = (ARCH == 32 ? '-i386' : '')
  config.vm.box = "opscode_ubuntu-12.04#{suffix}_chef-11.4.4"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04#{suffix}_chef-11.4.4.box"
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe("ubuntu")
    chef.add_recipe("nodejs")
    chef.add_recipe("maven")
    chef.add_recipe("android-sdk")
    chef.add_recipe("iidn-cli")
    chef.add_recipe("simple-example")
  end
  # Forward guest port 3000 to host port 3000
  config.vm.network :forwarded_port, guest: 3000, host: 3000
end
