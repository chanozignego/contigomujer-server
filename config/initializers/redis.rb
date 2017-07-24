redis_conn = proc {
  Redis.new(:host => '127.0.0.1', :port => (ENV["REDIS_PORT"] || 6379))
}

Redis.current = redis_conn.call

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 8, &redis_conn)
end
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 8, &redis_conn)
end
