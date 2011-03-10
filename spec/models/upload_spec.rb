require 'spec_helper'

describe Upload do
  before(:each) do
    @valid_attributes = {
      :uuid => "value for uuid",
      :path => "value for path",
      :comment => "value for comment"
    }
  end

  it "should create a new instance given valid attributes" do
    Upload.create!(@valid_attributes)
  end
end
