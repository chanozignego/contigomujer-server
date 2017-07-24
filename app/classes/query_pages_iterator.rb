class QueryPagesIterator

  attr_accessor :total_pages, :page, :query, :model, :count, :limit

  def initialize args={}
    @query = args[:query]
    @model = args[:model] 
    @count = args[:count].presence || @model.count
    @limit = args[:limit].presence || 1000
    @total_pages = args[:total_pages].presence || (@count / @limit.to_f).ceil
    @page = args[:page].presence || 1 
  end

  def find_in_batches options={}
    options = options.with_indifferent_access
    limit   = options[:batch_size].presence || self.limit
    @total_pages.times do |i|
      yield page_elements(i + 1, limit) if block_given?
    end
    nil
  end

  def page_elements page, limit = self.limit
    self.model.find_by_sql( paginated_query(page, limit) )
  end

  def paginated_query page, limit = self.limit
    offset = ([1, page].max - 1) * limit
    [self.query, "LIMIT #{limit}", "OFFSET #{offset}"].join(" ")    
  end

  def find_each &block
    self.find_in_batches do |elements|
      elements.each &block if block.present?
    end
    nil
  end

end