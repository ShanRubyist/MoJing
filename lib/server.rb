class Server
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers["Server"] = ENV['SITE_NAME']
    [status, headers, body]
  end
end