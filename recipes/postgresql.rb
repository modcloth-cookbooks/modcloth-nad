#
# Cookbook Name:: nad
# Recipe:: postgresql
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

include_recipe 'modcloth-nad::default'

template "#{node['nad']['prefix']}/etc/node-agent.d/postgresql/stats.sh" do
  source 'postgresql-stats.sh.erb'
  mode 0755
  notifies :run, 'execute[nad-update-index postgresql]'
end

template "#{node['nad']['prefix']}/etc/node-agent.d/postgresql/replication.sh" do
  source 'postgresql-replication.sh.erb'
  mode 0755
  notifies :run, 'execute[nad-update-index postgresql]'
  only_if do
    node['postgresql']['replication_user'] &&
      node['postgresql']['replication_password'] &&
      node['postgresql']['replication_master_hostname'] &&
      node['postgresql']['replication_standby_hostname']
  end
end

link "#{node['nad']['prefix']}/etc/node-agent.d/postgresql_stats.sh" do
  to "#{node['nad']['prefix']}/etc/node-agent.d/postgresql/stats.sh"
  notifies :restart, "service[#{node['nad']['service_name']}]"
end

link "#{node['nad']['prefix']}/etc/node-agent.d/postgresql_replication.sh" do
  to "#{node['nad']['prefix']}/etc/node-agent.d/postgresql/replication.sh"
  notifies :restart, "service[#{node['nad']['service_name']}]"
  only_if do
    node['postgresql']['replication_user'] &&
      node['postgresql']['replication_password'] &&
      node['postgresql']['replication_master_hostname'] &&
      node['postgresql']['replication_standby_hostname']
  end
end

link "#{node['nad']['prefix']}/etc/node-agent.d/pg_replication.sh" do
  to "#{node['nad']['prefix']}/etc/node-agent.d/postgresql/pg_replication.sh"
  notifies :restart, "service[#{node['nad']['service_name']}]"
  only_if do
    ::File.exists?("#{node['nad']['prefix']}/etc/node-agent.d/postgresql/pg_replication.sh")
  end
end
