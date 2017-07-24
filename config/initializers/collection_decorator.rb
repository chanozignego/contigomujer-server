# This is a dirty hack to fix Draper problem with kaminari
class Draper::CollectionDecorator    
   
    delegate :current_page, :total_pages, :limit_value  

    def total_count
      source.total_count
    end
    
end