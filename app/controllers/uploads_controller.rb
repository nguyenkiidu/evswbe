require 'zip'
class UploadsController < ApplicationController
  def create
    file = params[:file]
    dir = "public/uploads/3dtours/#{params[:userId]}"
    FileUtils.rm_r(dir, :force => true)
    file_path = Rails.root.join(dir, file.original_filename)
    FileUtils::mkdir_p dir
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end
    extract_zip(file_path, dir)
    if Dir[Rails.root.join("public/uploads/3dtours/#{params[:userId]}/*")].length == 2
      tour_url = "#{ENV['DOMAIN']}/uploads/3dtours/#{params[:userId]}/#{file.original_filename.split('.').first}/"
    else
      tour_url = "#{ENV['DOMAIN']}/uploads/3dtours/#{params[:userId]}/"
    end
    render json: { tour_url: tour_url }
  end

  private

  def extract_zip(file, destination)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        begin
          Rails.logger.debug "====#{f}"
          fpath = File.join(destination, f.name)
          zip_file.extract(f, fpath) unless File.exist?(fpath)
        rescue => e
          Rails.logger.debug "================#{e.message}"
        end
      end
    end
  end
end
