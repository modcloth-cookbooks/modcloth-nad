#
# Cookbook Name:: nad
# Recipe:: percona
#
# Copyright 2012, ModCloth, Inc!
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nad::default"

template "/opt/omni/etc/node-agent.d/percona.sh" do
  source "percona.sh.erb"
  mode "0755"
  notifies :restart, "service[circonus/nad]"
end
