action :run do
  execute "nad-update-index #{node['nad']['prefix']}/etc/node-agent.d/#{new_resource.name}"
  new_resource.updated_by_last_action(true)
end

action :nothing do
end
