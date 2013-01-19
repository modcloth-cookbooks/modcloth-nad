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

case node['platform']
when "smartos", "solaris2"
  git "/var/tmp/nad" do
    repository "git://github.com/omniti-labs/nad.git"
    reference "master"
    action :checkout
  end

  execute "make and install nad binary" do
    command "source /root/.profile && cd /var/tmp/nad && `which make` install"
    not_if "ls /opt/omni/etc/node-agent.d"
  end
  
  execute "install nad man page" do
    command "cp /var/tmp/nad/nad.8 /opt/local/man/man8/"
    not_if "ls -al /opt/local/man/man8/nad.8"
  end

  execute "compile C-extensions" do
    command "source /root/.profile && cd /opt/omni/etc/node-agent.d/smartos && `which test` -f Makefile && `which make`"
    not_if "ls /opt/omni/etc/node-agent.d/smartos/aggcpu.elf"
  end

  template "/opt/omni/etc/node-agent.d/smartos/link.sh" do
    source "link.sh.erb"
    mode "0755"
  end
  
  template "/opt/omni/etc/node-agent.d/smartos/memory.sh" do
    source "memory.sh.erb"
    mode "0755"
  end
  
  template "/opt/omni/etc/node-agent.d/smartos/disk.sh" do
    source "disk.sh.erb"
    mode "0755"
  end

  link "/opt/omni/etc/node-agent.d/aggcpu.elf" do
    to "/opt/omni/etc/node-agent.d/smartos/aggcpu.elf"
    notifies :restart, "service[circonus/nad]"
  end

  link "/opt/omni/etc/node-agent.d/sdinfo.sh" do
    to "/opt/omni/etc/node-agent.d/smartos/sdinfo.sh"
    notifies :restart, "service[circonus/nad]"
  end

  link "/opt/omni/etc/node-agent.d/zfsinfo.sh" do
    to "/opt/omni/etc/node-agent.d/smartos/zfsinfo.sh"
    notifies :restart, "service[circonus/nad]"
  end

  link "/opt/omni/etc/node-agent.d/vminfo.sh" do
    to "/opt/omni/etc/node-agent.d/smartos/vminfo.sh"
    notifies :restart, "service[circonus/nad]"
  end

  link "/opt/omni/etc/node-agent.d/link.sh" do
    to "/opt/omni/etc/node-agent.d/smartos/link.sh"
    notifies :restart, "service[circonus/nad]"
  end
  
  link "/opt/omni/etc/node-agent.d/memory.sh" do
    to "/opt/omni/etc/node-agent.d/smartos/memory.sh"
    notifies :restart, "service[circonus/nad]"
  end

  link "/opt/omni/etc/node-agent.d/disk.sh" do
    to "/opt/omni/etc/node-agent.d/smartos/disk.sh"
    notifies :restart, "service[circonus/nad]"
  end

  template "/tmp/nad.xml" do
    source "nad.erb"
  end

  execute "import the nad smf manifest" do
    # using our own template here to prevent exposing stuff to the world
    #command "svccfg import /var/tmp/nad/smf/nad.xml && svcadm enable nad"
    command "svccfg import /tmp/nad.xml"
    not_if "svcs -a | grep nad"
  end

  service "circonus/nad" do
    action :enable
  end

else
  Chef::Log.error("The 'nad' cookbook is not supported yet on #{node['os']}")
end

