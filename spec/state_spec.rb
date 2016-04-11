require 'spec_helper'

describe State do

  it "initializes an instance of State" do
    expect(@new_state).to be_an_instance_of State
  end

  it "allows the state.joined value to be true" do
    @new_state.joined = true    
    expect(@new_state.joined).to eq true
  end

  it "allows the state.addon_created value to be true" do
    @new_state.addon_created = true    
    expect(@new_state.addon_created).to eq true
  end
  it "allows the state.addon_copied value to be true" do
    @new_state.addon_copied = true    
    expect(@new_state.addon_copied).to eq true
  end
  it "allows the state.addon_promoted value to be true" do
    @new_state.addon_promoted = true    
    expect(@new_state.addon_promoted).to eq true
  end

  it "allows the state.finalized value to be true" do
    @new_state.finalized = true    
    expect(@new_state.finalized).to eq true
  end

end
