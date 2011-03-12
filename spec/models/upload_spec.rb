require 'spec_helper'

describe Upload do
  before(:each) do
    @valid_attributes = {
      :uuid => "schnippschnappschnupp",
      :original_filename => "Motörhead electro dance remix IXX.mp3",
      :title => "best track ever !"
    }
  end

  it "should create a new instance given valid attributes" do
    Upload.create!(@valid_attributes)
  end

  it "'s not valid without an uuid"
  it "'s not valid without data"
  it "generates the path from the uuid"
  it "generates a default uuid on initialize"
  it "uses a given uuid"
  it "gives out a default title if none is present"
  it "gets the size from the filesystem"
  it "saves data to disk after create"
  it "sets the original filename before and without saving"
end
