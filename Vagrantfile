# vim: set ft=ruby
#
# NOTE: requires both `vagrant-berkshelf` and `vagrant-omnibus` plugins

$centos_provision_script = <<-EOSHELL
yum install -q -y man git
EOSHELL
$ubuntu_provision_script = <<-EOSHELL
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -qq man git-core
EOSHELL

Vagrant.configure('2') do |config|
  {
    ubuntu: {
      box: 'canonical-ubuntu-12.04',
      box_url: 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box',
      inline_shell_provision: $ubuntu_provision_script,
      run_list: [
        'recipe[nodejs::install_from_package]',
        'recipe[modcloth-nad::default]',
        'recipe[modcloth-nad::autofs]',
        'recipe[modcloth-nad::percona]',
        'recipe[modcloth-nad::postgresql]',
        'minitest-handler'
      ]
    },
    :'ubuntu-vmware' => {
      box: 'precise64_vmware',
      box_url: 'http://files.vagrantup.com/precise64_vmware.box',
      inline_shell_provision: $ubuntu_provision_script,
      ip: '192.168.247.10',
      run_list: [
        'recipe[nodejs::install_from_package]',
        'recipe[modcloth-nad::default]',
        'recipe[modcloth-nad::autofs]',
        'recipe[modcloth-nad::percona]',
        'recipe[modcloth-nad::postgresql]',
        'minitest-handler'
      ]
    },
    centos: {
      box: 'nrel-centos-6.4',
      box_url: 'http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box',
      inline_shell_provision: $centos_provision_script,
      run_list: [
        'recipe[nodejs::install_from_source]',
        'recipe[modcloth-nad::default]',
        'recipe[modcloth-nad::autofs]',
        'recipe[modcloth-nad::percona]',
        'recipe[modcloth-nad::postgresql]',
        'minitest-handler'
      ]
    },
    # FIXME wat is up with this VM?
    # smartos: {
    #   box: 'aszeszo-smartos-base191-64',
    #   box_url: 'http://dlc-int.openindiana.org/aszeszo/vagrant/smartos-base191-64-virtualbox-20130405.box',
    # }
  }.each_with_index do |definition,i|
    boxname, cfg = definition

    config.vm.define boxname do |box|
      box.vm.hostname = "nad-berkshelf-#{boxname.to_s}"
      box.vm.box = cfg[:box]
      box.vm.box_url = cfg[:box_url]
      box.vm.network :private_network,
        ip: (cfg[:ip] || "33.33.33.#{10 + i}"),
        auto_correct: true
      box.vm.network :forwarded_port,
        guest: 2609,
        host: (12609 + i),
        auto_correct: true

      box.ssh.max_tries = 40
      box.ssh.timeout   = 120

      box.berkshelf.enabled = true

      box.omnibus.chef_version = :latest

      if cfg[:inline_shell_provision]
        box.vm.provision :shell, inline: cfg[:inline_shell_provision]
      end

      box.vm.provision :chef_solo do |chef|
        chef.log_level = ENV['DEBUG'] ? :debug : :info
        chef.json = {
          'nad' => {
            'use_private_interface' => false
          }
        }
        chef.run_list = cfg[:run_list]
      end
    end
  end
end
