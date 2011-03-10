class UploadsController < ApplicationController

  def new
    @upload = Upload.new
  end

  def show
    @upload = Upload.find(params[:id])
  end

  def create
    @upload = Upload.new(params[:upload])
    if @upload.save
      redirect_to :action => "show", :id => @upload.id
    else
      render :action => "new"
    end
  end
end
