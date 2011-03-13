require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Upload do
  before(:each) do
    @file_data = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    @original_filename = "Motörhead electro dance remix IXX.mp3"
    @valid_attributes = {
      :uuid => "schnippschnappschnupp",
      :title => "best track ever !",
      :data => mock("FileObject", :read => @file_data, :original_filename => @original_filename)
    }
  end

  it "should create a new instance given valid attributes" do
    Upload.create!(@valid_attributes)
  end

  it "'s not valid without an uuid" do
    u = Upload.new(@valid_attributes)
    u.uuid = nil
    u.should_not be_valid
  end

  it "'s not valid without data" do
    Upload.new(@valid_attributes.merge(:data => nil)).should_not be_valid
  end

  it "generates the path from the uuid" do
    Upload.new(:uuid => "uuid").path.should == "#{Rails.root}/public/uploads/uuid"
  end

  it "generates a default uuid on initialize" do
    Upload.new.uuid.should =~ /[a-z0-9]+/i
  end

  it "uses a given uuid" do
    Upload.new(:uuid => "uuid").uuid.should == "uuid"
  end

  it "gives out a default title if none is present" do
    Upload.new.title.should == "no title given"
  end

  it "gets the size in bytes from the filesystem" do
    File.open("public/uploads/test", "w+") do |f|
      f.write("X" * 10)
    end
    Upload.new(:uuid => "test").size.should == 10
  end

  it "saves data to disk after create" do
    path = "public/uploads/test2"
    File.delete(path) if File.exists?(path)
    Upload.create!(@valid_attributes.merge(:uuid => "test2"))
    File.open(path).read.should == @file_data
  end

  it "sets the original filename while saving" do
    u = Upload.create!(@valid_attributes)
    u.reload.original_filename.should == @original_filename
  end

  it "should delete the file when destroyed" do
    path = "public/uploads/test3"
    File.delete(path) if File.exists?(path)
    u = Upload.create!(@valid_attributes.merge(:uuid => "test3"))
    File.exists?(path).should be_true
    u.destroy
    File.exists?(path).should be_false
  end
end
