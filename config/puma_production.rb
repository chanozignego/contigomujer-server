threads 0, 2
workers 1

preload_app!

on_worker_boot do
  require "active_support"
  # Preloading
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

