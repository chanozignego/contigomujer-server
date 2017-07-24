require "searchlight/adapters/action_view"

class ItemSearch < Searchlight::Search
  include Searchlight::Adapters::ActionView

  def base_query
    options[:scope].presence || options["scope"].presence || Item.all
  end

  def search_created_at_gteq
    date = created_at_gteq.is_a?(String) ? Date.strptime(created_at_gteq, I18n.t("date.formats.calendar")) : created_at_gteq.to_date
    query.where(query.arel_table[:created_at].gteq(date.to_time.beginning_of_day))    
  end

  def search_created_at_lteq
    date = created_at_lteq.is_a?(String) ? Date.strptime(created_at_lteq, I18n.t("date.formats.calendar")) : created_at_lteq.to_date
    query.where(query.arel_table[:created_at].lteq(date.end_of_day))    
  end

  def search_price_gteq
    query.where(Item.arel_table[:price].gteq(price_gteq))
  end

  def search_price_lteq
    query.where(Item.arel_table[:price].lteq(price_lteq))
  end

  def search_number_eq
    query.where(number: search_number_eq)
  end

  def search_number_gteq
    query.where(query.arel_table[:number].gteq(number_gteq))
  end

  def search_number_lteq
    query.where(query.arel_table[:number].lteq(price_lteq))
  end

  def search_text
    query.where("items.title ILIKE :text OR items.description ILIKE ", text: "%#{text}%")
  end

  #
  # Search by Description
  #
  def search_description_contains
    query.where(query.arel_table[:description].matches("%#{description_contains}%"))
  end

  #
  # Search by Title
  #
  def search_title_contains
    query.where(query.arel_table[:title].matches("%#{title_contains}%"))
  end

  def id_not_eq
    id = "#{id}"
    query.where(query.arel_table[:id].not_eq(id))
  end

end