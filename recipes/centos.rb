#
# Cookbook Name:: nad
# Recipe:: centos
#
# Copyright 2012, ModCloth, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'nodejs' do
  action :install
end

git '/tmp/nad' do
  repository 'git://github.com/omniti-labs/nad.git'
  reference 'master'
  action :checkout
end

cookbook_file '/tmp/install_nad.sh' do
  source 'install_nad.sh'
  mode '0755'
end

execute 'make and install nad binary' do
  command '/tmp/install_nad.sh'
  not_if 'ls /opt/omni/etc/node-agent.d'
end

execute 'install nad man page' do
  command 'cp /tmp/nad/nad.8 /usr/share/man/man8/'
  not_if 'ls -al /usr/share/man/man8/nad.8'
end

directory '/opt/omni/etc/node-agent.d/centos' do
  action :create
end

template '/etc/init.d/nad' do
  source 'nad_init.erb'
  mode '0755'
end

cookbook_file '/opt/omni/etc/node-agent.d/centos/link.sh' do
  source 'link.sh'
  mode '0755'
end

cookbook_file '/opt/omni/etc/node-agent.d/centos/memory.sh' do
  source 'memory.sh'
  mode '0755'
end

cookbook_file '/opt/omni/etc/node-agent.d/centos/disk.sh' do
  source 'disk.sh'
  mode '0755'
end

link '/opt/omni/etc/node-agent.d/link.sh' do
  to '/opt/omni/etc/node-agent.d/centos/link.sh'
  notifies :restart, 'service[nad]'
end

link '/opt/omni/etc/node-agent.d/memory.sh' do
  to '/opt/omni/etc/node-agent.d/centos/memory.sh'
  notifies :restart, 'service[nad]'
end

link '/opt/omni/etc/node-agent.d/disk.sh' do
  to '/opt/omni/etc/node-agent.d/centos/disk.sh'
  notifies :restart, 'service[nad]'
end

service 'nad' do
  action :enable
  supports :enable => true, :disable => true, :restart => true
end
