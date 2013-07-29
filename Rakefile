require 'rspec/core/rake_task'
require 'foodcritic'

FoodCritic::Rake::LintTask.new do |t|
  t.options = {fail_tags: ['any']}
end
RSpec::Core::RakeTask.new

task default: :spec
