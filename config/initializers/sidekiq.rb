require 'sidekiq'
require 'sidekiq-status'

if Rails.env.development? || Rails.env.test?
  require 'sidekiq/testing/inline' 
  require 'sidekiq-status/testing/inline'
  Sidekiq::Testing.inline!
end

# Sidekiq.configure_client do |config|
#   config.client_middleware do |chain|
#     chain.add Sidekiq::Status::ClientMiddleware#, expiration: 30.minutes # default
#   end
# end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware#, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware#, expiration: 30.minutes # default
  end
end

