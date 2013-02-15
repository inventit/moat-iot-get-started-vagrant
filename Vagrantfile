# Either 32 or 64 is available
ARCH = 32

Vagrant::Config.run do |config|
  config.vm.box = "precise#{ARCH}"
  config.vm.box_url = "http://files.vagrantup.com/precise#{ARCH}.box"
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
  config.vm.forward_port 3000, 3000
end
