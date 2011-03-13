class UploadsController < ApplicationController

  def new
    @upload = Upload.new
  end

  def show
    @upload = Upload.find(params[:id])
  end

  def update
    @upload = Upload.find(params[:id])
    @upload.update_attribute(:title, params[:title])
    render :json => {:path => @upload.path, :title => @upload.title, :url => upload_url(@upload)}
  end

  def create
    if request.xhr?
      ajax_upload(request, params)
    else
      proper_upload(params)
    end
  end

  private

  def ajax_upload(request, params)
    @upload = Upload.new(
      :original_filename => params['qqfile'],
      :uuid => params['X-Progress-ID'],
      :file => request.body
     )
    if @upload.save
      render :json => {:success => true, :id => @upload.id}
    else
      request.body.read # Apparantly needed - otherwise apache get a broken pipe error
      render :json => {
        :success => false,
        # Should be done in JS, but can't get it working :/
        :errors => "<ul><li>#{@upload.errors.full_messages.join('</li><li>')}</li></ul>"
      }
    end
  end

  def proper_upload(params)
    @upload = Upload.new(params[:upload].merge(:uuid => params['X-Progress-ID']))
    if @upload.save
      redirect_to :action => "show", :id => @upload.id
    else
      render :action => "new"
    end
  end
end
