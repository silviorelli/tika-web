class ScansController < ApplicationController

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
