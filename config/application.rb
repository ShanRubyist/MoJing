require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TianLuo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    require 'server'
    config.middleware.use Server

    config.middleware.use Rack::Deflater

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: true,
                       routing_specs: true,
                       controller_specs: true,
                       request_specs: true

      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.eager_load_paths += %W(#{Rails.root}/app/jobs)

    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        address: ENV['SMTP_ADDRESS'],
        port: ENV['SMTP_PORT'],
        domain: ENV['SMTP_DOMAIN'],
        user_name: ENV['SMTP_USERNAME'],
        password: ENV['SMTP_PASSWORD'],
        authentication: :login,
        enable_startttls_auto: ENV['SMTP_STARTTTLS_AUTO'],
        ssl: ENV['SMTP_SSL']
    }

    config.view_component.preview_paths << "#{Rails.root}/spec/components/previews"
  end
end
