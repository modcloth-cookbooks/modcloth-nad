require 'minitest/spec'
require 'digest/md5'

describe 'modcloth-nad::default' do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  def cheftmp
    Chef::Config[:file_cache_path]
  end

  def md5(filepath)
    Digest::MD5.hexdigest(File.read(filepath))
  end

  it 'creates the ifconfig-private-ipv4 executable' do
    assert_sh 'which ifconfig-private-ipv4'
  end

  it 'clones nad into the file cache path' do
    directory("#{cheftmp}/nad").must_exist
  end

  it 'creates an upstart config' do
    skip if node['platform'] != 'ubuntu'
    file('/etc/init/nad.conf').must_exist
  end

  it 'creates an init script' do
    skip if node['platform'] != 'centos'
    file('/etc/init.d/nad').must_exist.with(:mode, 0755)
  end

  it 'installs nad' do
    directory("#{node['nad']['prefix']}/etc/node-agent.d").must_exist
  end

  it 'copies over the nad man page' do
    assert md5("#{cheftmp}/nad/nad.8") == md5("#{node['install_prefix']}/man/man8/nad.8")
    assert_sh 'man 8 nad >/dev/null'
  end

  it 'creates the nad-update-index executable' do
    assert_sh 'which nad-update-index'
  end

  it 'builds binary checks' do
    case node['os']
    when 'linux'
      file("#{node['nad']['prefix']}/etc/node-agent.d/linux/fs.elf").must_exist
    when 'solaris2', 'smartos', 'illumos'
      file("#{node['nad']['prefix']}/etc/node-agent.d/illumos/cpu.elf").must_exist
    end
  end
end
