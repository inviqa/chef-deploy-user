require 'chefspec'
require 'chefspec/berkshelf'

# Specify defaults -- these can be overridden
RSpec.configure do |config|
  config.log_level = :error # necessary to suppress all the WARNs for Chef resource cloning
end

at_exit { ChefSpec::Coverage.report! }
