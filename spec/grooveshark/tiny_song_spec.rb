require 'spec_helper'

describe TinySong do

  it 'should have a version' do
    TinySong::VERSION.should_not be_nil
  end

end
