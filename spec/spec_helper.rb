require './lib/state'
require './lib/colors' 
require './lib/App'

RSpec.configure do |config|
  config.before(:each) do
    @new_state = State.new
  end
end
