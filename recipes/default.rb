#
# Cookbook Name:: nad
# Recipe:: default
#
# Copyright (c) 2013 ModCloth, Inc.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

cookbook_file "#{node['install_prefix']}/bin/ifconfig-private-ipv4" do
  source 'ifconfig-private-ipv4'
  mode 0755
  owner 'root'
  group 'root'
  action :nothing
end.run_action(:create)

if node['nad']['use_private_interface'] && node['nad']['interface']['private'].nil?
  node.default['nad']['interface']['private'] =
    `#{RbConfig.ruby} -S ifconfig-private-ipv4`.chomp
end

if node['nad']['use_private_interface']
  server_address = "#{node['nad']['interface']['private']}:2609"
else
  server_address = '0.0.0.0:2609'
end

git "#{Chef::Config[:file_cache_path]}/nad" do
  repository node['nad']['git_repo']
  reference node['nad']['git_ref']
  action :sync
end

cookbook_file "#{Chef::Config[:file_cache_path]}/nad-hacks.patch" do
  source 'nad-hacks.patch'
end

execute "git checkout -- . && git apply #{Chef::Config[:file_cache_path]}/nad-hacks.patch" do
  cwd "#{Chef::Config[:file_cache_path]}/nad"
  not_if { ::File.directory?("#{node['nad']['prefix']}/etc/node-agent.d") }
end

bash 'make and install nad' do
  code "make #{node['nad']['install_target']}"
  cwd "#{Chef::Config[:file_cache_path]}/nad"
  not_if { ::File.directory?("#{node['nad']['prefix']}/etc/node-agent.d") }
end

execute "chown -R #{node['nad']['user']}:#{node['nad']['group']} #{node['nad']['prefix']}" do
  not_if do
    ::File.stat("#{node['nad']['prefix']}/etc").uid == Etc.getpwnam(node['nad']['user']).uid
  end
end

directory "#{node['install_prefix']}/man/man8" do
  mode 0755
  recursive true
end

link "#{node['install_prefix']}/man/man8/nad.8" do
  to "#{Chef::Config[:file_cache_path]}/nad/nad.8"
end

gem_package 'json'

cookbook_file "#{node['install_prefix']}/bin/nad-update-index" do
  source 'nad-update-index'
  mode 0755
  owner 'root'
  group 'root'
end

%w(
  common
  freebsd
  haproxy
  illumos
  linux
  ohai
  percona
  postgresql
  smartos
).each do |module_name|
  directory "#{node['nad']['prefix']}/etc/node-agent.d/#{module_name}" do
    mode 0755
  end

  execute "nad-update-index #{module_name}" do
    command "#{RbConfig.ruby} -S nad-update-index " <<
            "#{node['nad']['prefix']}/etc/node-agent.d/#{module_name}"
    action :nothing
  end
end

%w(
  noop.sh
).each do |common_check|
  template "#{node['nad']['prefix']}/etc/node-agent.d/common/#{common_check}" do
    source "#{common_check}.erb"
    notifies :run, 'execute[nad-update-index common]'
    mode 0755
  end
end

%w(
  boot_time.pl
  file_cksum.sh
  file_md5sum.sh
  file_stat.pl
  loadavg.pl
  net_listen.pl
  noop.sh
  open_files.sh
  process_memory.pl
  ps.pl
  user_logins.pl
).each do |common_check|
  link "#{node['nad']['prefix']}/etc/node-agent.d/#{common_check}" do
    to "#{node['nad']['prefix']}/etc/node-agent.d/common/#{common_check}"
    notifies :restart, "service[#{node['nad']['service_name']}]"
  end
end

link "#{node['nad']['prefix']}/etc/node-agent.d/ohai.sh" do
  to "#{node['nad']['prefix']}/etc/node-agent.d/ohai/ohai.sh"
  notifies :restart, "service[#{node['nad']['service_name']}]"
  notifies :run, 'execute[nad-update-index ohai]'
end

%w(
  disk.sh
  link.sh
  memory.sh
).each do |platform_check|
  template "#{node['nad']['prefix']}/etc/node-agent.d/#{node['platform']}/#{platform_check}" do
    source "#{platform_check}.erb"
    mode 0755
    notifies :run, 'execute[nad-update-index smartos]'
    only_if do
      ::File.directory?("#{node['nad']['prefix']}/etc/node-agent.d/#{node['platform']}")
    end
  end

  link "#{node['nad']['prefix']}/etc/node-agent.d/#{platform_check}" do
    to "#{node['nad']['prefix']}/etc/node-agent.d/#{node['platform']}/#{platform_check}"
    notifies :restart, "service[#{node['nad']['service_name']}]"
    only_if do
      ::File.exists?("#{node['nad']['prefix']}/etc/node-agent.d/#{node['platform']}/#{platform_check}")
    end
  end
end

template "#{Chef::Config[:file_cache_path]}/nad.xml" do
  source 'nad.xml.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(:server_address => server_address)
  notifies :run, 'execute[import-nad-smf-manifest]'
  only_if { platform?('smartos', 'solaris2') }
end

execute 'import-nad-smf-manifest' do
  # using our own template here to prevent exposing stuff to the world
  command "svccfg import #{Chef::Config[:file_cache_path]}/nad.xml"
  notifies :touch, "file[#{node['nad']['prefix']}/.nad-service-installed]"
  only_if { platform?('smartos', 'solaris2') }
end

template '/etc/init.d/nad' do
  source 'nad_init.erb'
  mode 0755
  owner 'root'
  group 'root'
  variables(:server_address => server_address)
  notifies :touch, "file[#{node['nad']['prefix']}/.nad-service-installed]"
  notifies :restart, "service[#{node['nad']['service_name']}]"
  only_if { platform?('centos') }
end

template '/etc/init/nad.conf' do
  source 'nad.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(:server_address => server_address)
  notifies :touch, "file[#{node['nad']['prefix']}/.nad-service-installed]"
  notifies :restart, "service[#{node['nad']['service_name']}]"
  only_if { platform?('ubuntu') }
end

service node['nad']['service_name'] do
  provider(platform?('ubuntu') ? Chef::Provider::Service::Upstart : nil)
  action(platform?('smartos', 'solaris2') ? [:enable, :start] : :nothing)
end

file "#{node['nad']['prefix']}/.nad-service-installed" do
  mode 0644
  notifies :enable, "service[#{node['nad']['service_name']}]"
  notifies :start, "service[#{node['nad']['service_name']}]"
  action :nothing
  not_if { ::File.exists?("#{node['nad']['prefix']}/.nad-service-installed") }
end
