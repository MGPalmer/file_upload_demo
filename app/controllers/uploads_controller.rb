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
      if params['qqfile']
        ie_iframe_upload(params)
      else
        proper_upload(params)
      end
    end
  end

  private

  def ajax_upload(request, params)
    file, original_filename = if !params['qqfile'].is_a?(String)
      [params['qqfile'], nil]
    else
      [request.body, params['qqfile']]
    end
    @upload = Upload.new(
      :original_filename => original_filename,
      :uuid => params['X-Progress-ID'],
      :file => file
     )
    save_and_render_json(@upload, :json)
  end

  def proper_upload(params)
    @upload = Upload.new(params[:upload].merge(:uuid => params['X-Progress-ID']))
    if @upload.save
      redirect_to :action => "show", :id => @upload.id
    else
      render :action => "new"
    end
  end

  def ie_iframe_upload(params)
    @upload = Upload.new(
      :uuid => params['X-Progress-ID'],
      :file => params['qqfile']
     )
     save_and_render_json(@upload, :text)
  end

  # Grrr, IE tries to download the JSON response if (correctly) flagged as json.
  def save_and_render_json(upload, how)
    if upload.save
      render how => {:success => true, :id => upload.id}.to_json
    else
      request.body.read # Apparantly needed - otherwise apache get a broken pipe error
      render how => {
        :success => false,
        # Should be done in JS, but can't get it working :/
        :errors => "<ul><li>#{upload.errors.full_messages.join('</li><li>')}</li></ul>"
      }.to_json
    end
  end
end
