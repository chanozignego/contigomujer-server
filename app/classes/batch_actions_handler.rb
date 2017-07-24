# @class: BatchActionsHandler
# stores every worker id for each batch action executed in each model
# only allows to start a batch action in a model if there isn't another batch action active updating the same column/s
require 'thread'
class BatchActionsHandler

  attr_accessor :workers, :semaphore#, :models

  ################## SINGLETON PATTERN ###########################  

  def initialize args={}
    args = args.with_indifferent_access
    @semaphore = Mutex.new
    @workers   = args[:workers].presence || []
  end

  @@instance = BatchActionsHandler.new
  private_class_method :new

  def self.instance
    @@instance
  end

  #############################################

  # This defines the methods scope_from_worker and fields_from_worker
  [:scope, :fields].each do |attribute|
    define_method "#{attribute}_from_worker" do |id|
      self.workers[id][attribute] unless self.workers[id].blank?
    end
  end

  # Returns a hash with the data associated to the worker for the given id
  # Returns nil if there is no data associated to the given id
  def find_worker id
    self.workers.find{ |worker| worker[:id] == id }    
  end

  # Receives a worker id
  # Returns true if the worker id is in the workers list 
  # Otherwise returns false
  def worker_exists? id
    find_worker(id).present?
  end

  # Returns the model class from the worker if the worker exists and if it has a defined model
  # Otherwise returns false
  def model_from_worker id
    find_worker(id)[:model].to_s.safe_constantize if worker_exists?(id)
  end

  def worker_ids
    self.workers.map{ |worker| worker[:id]}
  end

  # Returns an array with workers associated to the given model
  def workers_from_model model
    self.workers.select { |worker| worker[:model] == model.to_s.camelize }
  end

  # Returns an array with worker ids associated to the given model
  def worker_ids_from_model model
    workers_from_model(model).map{ |worker| worker[:id] }
  end

  # Returns an array with the model affected fields by the running workers
  def fields_from_model model
    workers_from_model(model).map{ |worker| Array(worker[:fields]) }.flatten
  end

  # Returns the called methods by every worker associated to the given model
  def methods_from_model model
    workers_from_model(model).map{ |worker| worker[:method].to_s }.reject(&:blank?)
  end

  # Returns the model fields affected by the given method 
  def fields_from_model_method model, method
    data = (model.to_s.camelize.safe_constantize.try(:batch_actions_data).presence || {}).with_indifferent_access
    Array(data[method])
  end

  def worker_complete_statuses
    [nil, false, :complete, :stopped, :failed, :interrupted ]
  end

  # Check each worker status and remove the finished workers from the list
  def update_workers
    self.workers.delete_if do |worker| 
      worker_complete_statuses.include?( Sidekiq::Status::status(worker[:id]) )
    end
  end
  
  # Returns true if there is a worker running the given method for the given model
  # Otherwise returns false
  def already_running_model_method? model, method
    methods_from_model(model).include?(method.to_s)
  end

  # Returns true if any of the the model fields affected by the given method is being affected by the running workers
  # Otherwise returns false 
  def update_same_fields? model, method
    intersection = fields_from_model(model).map(&:to_s) & fields_from_model_method(model, method).map(&:to_s)
    intersection.present?
  end

  def update_different_fields? model, method
    !update_same_fields(model, method)    
  end

  # Checks if the batch action can be initialized
  # if it can, then initializes the batch action 
  # if it can't, it does nothing
  # returns a hash with two keys:
  #                             started -> true if the batch action was initialized 
  #                             message -> a text message
  def start_batch_action method, scope, options={}
    options  = options.with_indifferent_access
    model = ( options[:model] || scope.try(:klass) ).to_s.camelize
    already_running_message = options[:already_running_message].presence || I18n.t("batch_actions.same_worker_still_running")
    another_worker_running_message = options[:another_worker_running_message].presence || I18n.t("batch_actions.another_worker_still_running")
    started_worker_message = options[:started_worker_message].presence || I18n.t("batch_actions.started_worker")
    semaphore.synchronize do
      update_workers
      return { started: false, message: already_running_message }.with_indifferent_access if already_running_model_method?(model, method)
      return { started: false, message: another_worker_running_message }.with_indifferent_access if update_same_fields?(model, method)
      create_worker(model, method, scope, method_args: options[:method_args]) and return { started: true, message: started_worker_message }.with_indifferent_access
    end
  end

  # this method starts a new worker for the given method and store the worker id and the scope
  # which will be used inside the worker to iterate over the records
  def create_worker model, method, scope, options = {}
    options = options.with_indifferent_access
    model   = model.to_s.camelize
    data = {method: method, model: model, method_args: options[:method_args], query: scope.to_sql, count: scope.count }
    worker_id   = BatchActionsWorker.perform_async(data)
    worker_data = ( 
          { id: worker_id, fields: fields_from_model_method(model, method) }
          .with_indifferent_access)
          .merge(data)
    workers.push(worker_data)
  end

end