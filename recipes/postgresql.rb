#
# Cookbook Name:: nad
# Recipe:: postgresql
#
# Copyright 2012, ModCloth, Inc!
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nad::default"

template "/opt/omni/etc/node-agent.d/postgresql.sh" do
  source "postgresql.sh.erb"
  mode "0755"
  notifies :restart, "service[circonus/nad]"
end
