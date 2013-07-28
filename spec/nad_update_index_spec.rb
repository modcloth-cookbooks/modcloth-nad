require 'fileutils'
load File.expand_path('../../files/default/nad-update-index', __FILE__)

describe 'nad-update-index' do
  let(:tmp) { Dir.mktmpdir }
  let(:fancy_number) { rand(1..99) }

  before do
    if ENV['DEBUG']
      $stderr.puts "Using temporary directory #{tmp}"
    end

    Dir.chdir(tmp) do
      File.write('sleep.sh', 'echo "zzz\tn\t1"')
      File.write('fancy.sh', <<-EOF.gsub(/^ {8}/, ''))
        #!/bin/bash
        # Description: easily #{fancy_number}x fancier than sleep.sh
        echo "sequins\\tn\\t#{fancy_number * 10}"
      EOF
      File.write('zap.elf', "\xb1\x00")
    end
  end

  context 'when generating a module index' do
    let(:index) { generate_module_index(tmp) }

    it 'indexes all files with extensions' do
      %w(sleep.sh fancy.sh zap.elf).map { |k| index[k] }.each do |value|
        value.should_not be_nil
      end
    end

    it 'describes scripts with descriptions' do
      index['fancy.sh'].should == "easily #{fancy_number}x fancier than sleep.sh"
    end

    it 'does not describe scripts without descriptions' do
      index['sleep.sh'].should == ''
    end

    it 'does not describe binaries' do
      index['zap.elf'].should == ''
    end
  end
end
