RSpec.configure do |config|
  if ENV['TRAVIS']
    config.formatter = :documentation
  end
end
