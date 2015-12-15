class ScansController < ApplicationController
  require 'rest_client'

  def index
    @scans = Scan.all
  end
  
  def show
    @scan = Scan.where(id: params[:id]).first
  end

  def new
    @scan = Scan.new
  end

  def create
    @scan = Scan.new

    @scan.filename = params[:scan][:file].original_filename
    
    # Save file to disk
    directory = "public/uploads"
    FileUtils.mkdir_p directory
    path = File.join(directory, @scan.filename)
    File.open(path, "wb") { |f| f.write(params[:scan][:file].read) }

    # Call to tika server
    begin
      tika_out = ""
      
      #### Can't make it work, always getting "405 Method Not Allowed" 
      # file = File.open(path, "r")
      # RestClient.post('http://0.0.0.0:9998/meta', upload: file)

      #### Other way
      # JSON output
      #tika_out = `curl -H \"Accept: application/json\" -T #{path} http://0.0.0.0:9998/meta`

      # Plaintext output
      tika_out = `curl -T #{path} http://0.0.0.0:9998/meta`

      @scan.body = tika_out
    rescue
      @scan.body = "Error"
    end

    @scan.save
    redirect_to scan_path(@scan)
  end

  def destroy
    @scan = Scan.where(id: params[:id]).first
    @scan.destroy
    redirect_to root_path
  end

end
