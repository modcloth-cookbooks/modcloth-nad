require 'json'

action :run do
  mod = "#{node['nad']['prefix']}/etc/node-agent.d/#{new_resource.name}"

  if ::File.directory?(mod)
    ::File.open("#{mod}/.index.json", 'w') do |f|
      f.puts JSON.pretty_generate(generate_module_index(mod))
    end

    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end

action :nothing do
end

private

def generate_module_index(mod)
  index = {}

  Dir.glob("#{mod}/*.*").each do |script|
    if ::File.file?(script)
      index[::File.basename(script)] = script_description(script)
    end
  end

  index
end

def script_description(script)
  if %w(.elf .bin).include?(::File.extname(script))
    ''
  else
    (::File.read(script).split($/).grep(/Description:/).first || '').
      sub(/.*Description:/, '').strip
  end
end
