# vim: set ft=ruby
#
# NOTE: requires both `vagrant-berkshelf` and `vagrant-omnibus` plugins

Vagrant.configure('2') do |config|
  i = 0
  {
    ubuntu: {
      box: 'canonical-ubuntu-12.04',
      box_url: 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box',
    },
    # FIXME wat is up with this VM?
    # smartos: {
    #   box: 'aszeszo-smartos-base191-64',
    #   box_url: 'http://dlc-int.openindiana.org/aszeszo/vagrant/smartos-base191-64-virtualbox-20130405.box',
    # }
  }.each do |boxname,cfg|
    config.vm.define boxname do |box|
      box.vm.hostname = "nad-berkshelf-#{boxname.to_s}"
      box.vm.box = cfg[:box]
      box.vm.box_url = cfg[:box_url]
      box.vm.network :private_network, ip: "33.33.33.#{10 + i}"
      box.vm.network :forwarded_port, guest: 2609, host: 12609 + i

      box.ssh.max_tries = 40
      box.ssh.timeout   = 120

      box.berkshelf.enabled = true

      box.omnibus.chef_version = :latest

      box.vm.provision :chef_solo do |chef|
        chef.log_level = ENV['DEBUG'] ? :debug : :info
        chef.json = {
          'nad' => {
            'use_private_interface' => false
          }
        }
        chef.run_list = [
          'recipe[git]',
          'recipe[nodejs::install_from_package]',
          'recipe[modcloth-nad::default]',
          'recipe[modcloth-nad::autofs]',
          'recipe[modcloth-nad::dns]',
          'recipe[modcloth-nad::percona]',
          'recipe[modcloth-nad::postgresql]'
        ]
      end

      i += 1
    end
  end
end
