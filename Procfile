puma:         bundle exec puma -e $RAILS_ENV -S ~/puma -C config/puma_$RAILS_ENV.rb -b unix:///tmp/$SOCK_NAME
redis:        redis-server --port $REDIS_PORT --bind 127.0.0.1
sidekiq:      bundle exec sidekiq -c 2
