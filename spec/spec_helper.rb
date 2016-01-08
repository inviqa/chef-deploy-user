require 'chefspec'
require 'chefspec/berkshelf'

# Specify defaults -- these can be overridden
RSpec.configure do |config|
  # necessary to suppress all the WARNs for Chef resource cloning
  config.log_level = :error
end

at_exit { ChefSpec::Coverage.report! }
