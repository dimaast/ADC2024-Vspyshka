Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost", "http://127.0.0.1", /http:\/\/192\.168\.\d{1,3}\.\d{1,3}/, "http://localhost:3000",
            # iOS Simulator
            "http://localhost:8080", "http://127.0.0.1:8080",
            # iOS Device (замените на ваш IP)
            /http:\/\/10\.\d{1,3}\.\d{1,3}\.\d{1,3}/,
            # Production domains (добавьте ваши домены)
            "https://yourdomain.com", "https://api.yourdomain.com"
    
    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true,
      expose: ['Authorization', 'Content-Type', 'X-Requested-With']
  end
end
