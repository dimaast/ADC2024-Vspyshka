Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost', 'http://127.0.0.1', /http:\/\/192\.168\.\d{1,3}\.\d{1,3}/, 'http://localhost:3000'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end