#
# Cookbook Name:: nad
# Recipe:: default
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

git "/var/tmp/nad" do
  repository "git://github.com/omniti-labs/nad.git"
  reference "master"
  action :checkout
end

execute "make-install nad" do
  command "source /root/.profile && cd /var/tmp/nad && `which make` install"
  # these checks include an extra space in the grep to avoid stuff in the "online*" state
  not_if "svcs -H nad | grep \"online \""
end

execute "compile C-extensions" do
  command "source /root/.profile && cd /opt/omni/etc/node-agent.d/smartos && `which test` -f Makefile && `which make`"
  not_if "svcs -H nad | grep \"online \""
end

template "/opt/omni/etc/node-agent.d/smartos/link.sh" do
  source "link.sh.erb"
end

execute "symlink default nad plugins" do
  command "cd /opt/omni/etc/node-agent.d && ln -s smartos/aggcpu.elf && ln -s smartos/zfsinfo.sh  && ln -s smartos/vminfo.sh && ln -s smartos/link.sh"
  not_if "svcs -H nad | grep \"online \""
end

template "/tmp/nad.xml" do
  source "nad.erb"
end

execute "import the nad smf manifest" do
  # using our own template here to prevent exposing stuff to the world
  #command "svccfg import /var/tmp/nad/smf/nad.xml && svcadm enable nad"
  command "svccfg import /tmp/nad.xml"
  not_if "svcs -H nad | grep \"online \""
end

service "nad" do
  action :enable
end
