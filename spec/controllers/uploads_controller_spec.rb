require 'spec_helper'

describe UploadsController do

  integrate_views

  before(:each) do
    setup_upload_instance_vars
    @upload = Upload.create!(@valid_attributes)
  end

  it "finds the upload for show" do
    get :show, :id => @upload.id
    assigns[:upload].should == @upload
  end

  it "gets a new upload for new" do
    get :new
    assigns[:upload].should be_a_kind_of(Upload)
  end

  it "updates the title of an upload and displays json data with update" do
    title = "Swing that Gospel axe !"
    post :update, :id => @upload.id, :title => title
    JSON.parse(response.body).should == {
      "title" => title,
      "url" => "http://test.host/uploads/1",
      "path"=> @upload.path
    }
  end

  it "munges parameters into model form on create with xhr and returns json on success" do
    request.should_receive(:body).and_return(mock("IO", :read => "X" * 10))
    xhr :post, :create, :qqfile => "filename", 'X-Progress-ID' => "xyz123"
    u = Upload.find_by_uuid("xyz123")
    File.open(u.path).read.should == 'X' * 10
    u.original_filename.should == "filename"
    JSON.parse(response.body).should == {"success" => true, "id" => u.id}
  end

  it "adds the uuid from parameters into model params and redirects to show on create without xhr" do
    post :create, 'X-Progress-ID' => "xyz123", :upload => { :file => mock("IO", :read => "Y" * 10, :original_filename => "filename"), :title => "the title"}
    u = Upload.find_by_uuid("xyz123")
    File.open(u.path).read.should == 'Y' * 10
    u.original_filename.should == "filename"
    response.should redirect_to(:action => 'show', :id => u.id)
  end

  it "shows the form with errors again on create without xhr" do
    post :create, 'X-Progress-ID' => "xyz123", :upload => { :data => nil }
    response.should render_template('uploads/new')
  end

  it "renders the errors as json and a message for the fileuploader lib with xhr" do
    request.should_receive(:body).any_number_of_times.and_return(mock("IO", :read => nil))
    xhr :post, :create, 'X-Progress-ID' => "xyz123", 'qqfile' => "filename"
    JSON.parse(response.body).should == {
      "success" => false,
      "errors" => "<ul><li>Data Please choose a file to upload.</li></ul>"
    }
  end

end
