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

if node['nad']['use_private_interface'] && node['nad']['interface']['private'].nil?
  node.default['nad']['interface']['private'] = private_interface_ipv4
                          # NOTE lives in ./libraries/nad.rb ---^
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

bash 'make and install nad binary' do
  code 'make install'
  cwd "#{Chef::Config[:file_cache_path]}/nad"
  not_if { ::File.directory?("#{node['nad']['prefix']}/etc/node-agent.d") }
end

directory "#{node['install_prefix']}/man/man8" do
  mode 0755
end

execute 'install nad man page' do
  command "cp #{Chef::Config[:file_cache_path]}/nad/nad.8 #{node['install_prefix']}/man/man8/"
  not_if { ::File.exists?("#{node['install_prefix']}/man/man8/nad.8") }
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

  modcloth_nad_update_index module_name do
    action :nothing
  end
end

node_os = node['os'] == 'solaris2' ? 'illumos' : node['os']

file "#{Chef::Config[:file_cache_path]}/nad-build-extensions.sh" do
  content <<-EOBASH.gsub(/^ {4}/, '')
    #!/bin/bash
    set -e
    cd #{node['nad']['prefix']}/etc/node-agent.d/#{node_os}
    if [ -f Makefile ] ; then
      make
    fi
  EOBASH
  mode 0755
end

bash "compile c extensions for #{node_os}" do
  code "#{Chef::Config[:file_cache_path]}/nad-build-extensions.sh"

  notifies :run, "modcloth-nad_update_index[#{node_os}]"
  not_if do
    ::File.exists?("#{node['nad']['prefix']}/etc/node-agent.d/#{node_os}/fs.elf")
  end
  only_if do
    ::File.directory?("#{node['nad']['prefix']}/etc/node-agent.d/#{node_os}")
  end
end

%w(
  disk.sh
  noop.sh
).each do |common_check|
  template "#{node['nad']['prefix']}/etc/node-agent.d/common/#{common_check}" do
    source "#{common_check}.erb"
    notifies :restart, "service[#{node['nad']['service_name']}]"
    notifies :run, 'modcloth-nad_update_index[common]'
    mode 0755
  end
end

%w(
  boot_time.pl
  disk.sh
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
  end
end

%w(
  link.sh
  memory.sh
).each do |smartos_check|
  template "#{node['nad']['prefix']}/etc/node-agent.d/smartos/#{smartos_check}" do
    source "smartos-#{smartos_check}.erb"
    mode 0755
    notifies :restart, "service[#{node['nad']['service_name']}]"
    notifies :run, 'modcloth-nad_update_index[smartos]'
    only_if { platform?('smartos', 'solaris2') }
  end

  link "#{node['nad']['prefix']}/etc/node-agent.d/#{smartos_check}" do
    to "#{node['nad']['prefix']}/etc/node-agent.d/smartos/#{smartos_check}"
    only_if { platform?('smartos', 'solaris2') }
  end
end

%w(
  aggcpu.elf
  cpu.elf
  fs.elf
).each do |illumos_check|
  link "#{node['nad']['prefix']}/etc/node-agent.d/#{illumos_check}" do
    to "#{node['nad']['prefix']}/etc/node-agent.d/illumos/#{illumos_check}"
    only_if { platform?('smartos', 'solaris2') }
  end
end

%w(
  fs.elf
).each do |linux_check|
  link "#{node['nad']['prefix']}/etc/node-agent.d/#{linux_check}" do
    to "#{node['nad']['prefix']}/etc/node-agent.d/linux/#{linux_check}"
    only_if { platform?('ubuntu') }
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
  action :nothing
  notifies :restart, "service[#{node['nad']['service_name']}]"
  only_if { platform?('smartos', 'solaris2') }
end

service "#{node['nad']['service_name']}" do
  provider(platform?('ubuntu') ? Chef::Provider::Service::Upstart : nil)
  action :nothing
end

execute "enable and start #{node['nad']['service_name']}" do
  command 'true'
  notifies :enable, "service[#{node['nad']['service_name']}]"
  notifies :start, "service[#{node['nad']['service_name']}]"
end

template '/etc/init/nad.conf' do
  source 'nad.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(:server_address => server_address)
  notifies :restart, "service[#{node['nad']['service_name']}]"
  only_if { platform?('ubuntu') }
end
