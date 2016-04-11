require 'rspec'
require 'state'

describe State do

  before do
    @new_state = State.new
  end

  it "initializes an instance of State" do
    expect(@new_state).to be_an_instance_of State
  end

  it "allows the state.joined value to be true" do
    @new_state.joined = true    
    expect(@new_state.joined).to eq true
  end

end
