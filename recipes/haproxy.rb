#
# Cookbook Name:: nad
# Recipe:: haproxy
#
# Copyright 2012, ModCloth, Inc!
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nad::default"

package netcat6 do
  action :install
end

template "/opt/omni/etc/node-agent.d/haproxy.sh" do
  source "haproxy.sh.erb"
  mode "0755"
  notifies :restart, "service[circonus/nad]"
end
