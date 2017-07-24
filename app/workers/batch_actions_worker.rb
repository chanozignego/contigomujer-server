class BatchActionsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform options={}
    options     = options.with_indifferent_access
    model       = options[:model].to_s.constantize
    method      = options[:method]
    method_args = options[:method_args]
    @iterator = QueryPagesIterator.new model: model, query: options[:query], count: options[:count]

    puts "Started Batch Action #{method.to_s} on class #{model.to_s}"
    @iterator.find_each do |entity|
      method_args.present? ? entity.send(method, method_args) : entity.send(method)
      entity.save unless ["destroy", "destroy!"].include?(method.to_s)
    end   
    puts "Finalizing Batch Action #{method.to_s} on class #{model.to_s}"

  rescue StandardError => error
    puts "Error...finalizing Batch Action #{method.to_s} on class #{model.to_s}"

  end


end