class CoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::Vips
  include CarrierWave::ImageOptimizer

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[jpg jpeg png]
  end

  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename
  end

  protected

  def secure_token(length = 16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

  def asset_host
    "http://localhost:3000"
  end
end