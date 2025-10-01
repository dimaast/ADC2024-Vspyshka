class Api::V1::UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_jwt

  # POST /api/v1/uploads
  def create
    begin
      user = User.find_by_jti(decrypt_payload[0]["jti"])
      
      unless user
        return render json: { error: "Unauthorized" }, status: :unauthorized
      end

      if params[:file].present?
        # Создаем временный файл для загрузки
        temp_file = Tempfile.new(['upload', File.extname(params[:file].original_filename)])
        temp_file.binmode
        temp_file.write(params[:file].read)
        temp_file.rewind

        # Генерируем уникальное имя файла
        filename = "#{SecureRandom.hex(10)}#{File.extname(params[:file].original_filename)}"
        
        # Сохраняем файл в публичную папку
        upload_path = Rails.root.join('public', 'uploads', 'api', filename)
        FileUtils.mkdir_p(File.dirname(upload_path))
        FileUtils.cp(temp_file.path, upload_path)
        temp_file.close
        temp_file.unlink

        # Возвращаем URL файла
        file_url = "#{request.base_url}/uploads/api/#{filename}"
        
        render json: {
          success: true,
          file_url: file_url,
          filename: filename,
          original_filename: params[:file].original_filename,
          content_type: params[:file].content_type,
          size: params[:file].size
        }, status: :created
      else
        render json: { error: "No file provided" }, status: :bad_request
      end
    rescue => e
      render json: { error: "Upload failed: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def authenticate_user_jwt
    begin
      decrypt_payload
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Authentication failed" }, status: :unauthorized
    end
  end

  def decrypt_payload
    jwt = request.headers["Authorization"]
    raise "No authorization header" if jwt.blank?
    
    token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: "HS256" })
    token
  end
end
