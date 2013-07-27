require 'json'

action :run do
  index = {}

  mod = "#{node['nad']['prefix']}/etc/node-agent.d/#{new_resource.name}"

  if !::File.directory?(mod)
    return
  end

  Dir.glob("#{mod}/*.*").each do |script|
    if ::File.file?(script) && ::File.executable?(script)
      index[::File.basename(script)] = (
        ::File.read(script).split($/).grep(/Description:/).first || ''
      ).sub(/.*Description:/, '').strip
    end
  end

  ::File.open("#{mod}/.index.json", 'w') do |f|
    f.puts JSON.pretty_generate(index)
  end

  new_resource.updated_by_last_action(true)
end

action :nothing do
end
