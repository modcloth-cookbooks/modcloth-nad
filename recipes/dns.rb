#
# Cookbook Name:: nad
# Recipe:: dns
#
# Copyright 2012, ModCloth, Inc!
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nad::default"

template "/opt/omni/etc/node-agent.d/dns_stats.sh" do
  source "dns_stats.sh.erb"
  mode "7755"
  notifies :restart, "service[circonus/nad]"
end
