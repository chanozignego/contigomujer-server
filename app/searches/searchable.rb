#
# This module provides general methods to a Search class that MUST extend from Searchlight::Search
# It provides a set of methods persisted class attributes. Methods ar attribute_eq, attribute_not_eq, attribute_matches,
# attribute_does_not_match, attribute_lt, attribute_gt, attribute_lte, attribute_gte, attribute_in, attribute_not_in, attribute_cont,
# attribute_not_cont, attribute_start, attribute_not_start, attribute_end, attribute_not_end
# More info: https://github.com/nathanl/searchlight
#

module Searchable
  
  @@suffix = /Search/
  @@replace = ""
  
  # Searchable.method_prefix is method's prefix, e.g: search_id
  @@method_prefix = "search_"
  @@sort_matcher = /sort_/
  @@sort_prefix = "sort_"

  class << self
    ["suffix", "replace", "method_prefix", "sort_matcher", "sort_prefix"].each do |method|
      define_method method do
        self.class_variable_get("@@#{method}")
      end

      define_method "#{method}=" do |value|
        self.class_variable_set("@@#{method}", value)
      end
    end
  end

  def self.configure
    yield self if block_given?
  end


  module Finder

    class SearchError < StandardError
    end

    def self.parse_class(klazz)
      klazz.to_s.gsub(Searchable.suffix, Searchable.replace).constantize rescue raise SearchError.new "#{klazz.to_s} is not a valid constant."
    end
  end
  
  module Base

    # To join models, you should redefine methods like this:
    # => UserSearch class
    #
    # def search_addresses_number_eq
    #   query.joins(:addresses).where("addresses.number = #{options[:addresses_number_eq]}")
    # end
    #
  
    # Rules are defined like [suffix, operation, special_char_left, special_char_right, is_not_string]
    # e.g: ["_lt", "<", "", "", true] => MymodelSearch.new(attribute_lt: value).results => SELECT * from my_models WHERE my_models.attribute < value
    LIKE = "ILIKE"
    RULES = [["_eq", "="], 
            ["_not_eq", "!="], 
            ["_matches", "#{LIKE}"], 
            ["_does_not_match", "NOT #{LIKE}"], 
            ["_lt", "<", "", "", true], 
            ["_gt", ">", "", "", true], 
            ["_lte", "<=", "", "", true], 
            ["_gte", ">=", "", "", true], 
            ["_in", "IN", "(", ")", true], 
            ["_not_in", "NOT IN", "(", ")", true], 
            ["_cont", "#{LIKE}", "%", "%"], 
            ["_not_cont", "NOT #{LIKE}", "%", "%"], 
            ["_start", "#{LIKE}", "%"],
            ["_not_start", "NOT #{LIKE}", "%"], 
            ["_end", "#{LIKE}", "", "%"], 
            ["_not_end", "NOT #{LIKE}", "", "%"]]

    attr_accessor :klazz, :table_name, :klazz_attributes
    def initialize(raw_options = {})
      @klazz = Finder.parse_class(self.class)
      @table_name = @klazz.table_name
      generate_default_methods(@klazz.attribute_names)
      super(raw_options)
    end

    def base_query
      options[:scope].presence || options["scope"].presence || @klazz.all
    end

    private
    def define_query_method(method_name, &block)
      self.class.send :define_method, method_name, block
    end

    def get_table_attribute(attribute)
      "#{@table_name}.#{attribute}"
    end

    def generate_default_methods(attributes)
      attributes.each{|attribute| define_searchs(attribute)}
    end

    def define_searchs(attribute)
      RULES.each do |suffix, keyword, search_prefix, search_suffix, is_not_string|
        define_query_method :"#{Searchable.method_prefix}#{attribute}#{suffix}" do
          value = "#{search_prefix}#{get_search_value(attribute + suffix)}#{search_suffix}"
          query.where("#{get_table_attribute(attribute)} #{keyword} #{!is_not_string ? "?" : value}", "#{value if !is_not_string}")
        end
      end
      ["null", "not_null"].each{ |is_method| define_method_with_is(attribute, is_method) }
    end

    def get_search_value(attribute)
      value = self.instance_eval(attribute)
      if value.is_a?(Array)
        value.join(", ")
      else
        value
      end
    end

    def define_method_with_is(attribute, type)
      define_query_method :"#{Searchable.method_prefix}#{attribute}_#{type}" do
        query.where("#{get_table_attribute(attribute)} IS #{type.split("_").join(" ").upcase}")
      end
    end
  end

  module Sort
    def initialize(raw_options = {})
      super(raw_options)
      @sort_methods = raw_options.select{|key| Searchable.sort_matcher =~ key.to_s}
      generate_sort_methods(@klazz.attribute_names)
    end

    def generate_sort_methods(attributes)
      attributes.each{|attr| define_sort(attr)}
    end

    def run
      super
      @sort_methods.each_key{|method| self.query = self.send(method)}
      query
    end

    def define_sort(attr)
      name = "#{Searchable.sort_prefix}#{attr}"
      self.class.send :define_method, :"#{name}" do
        query.order("#{attr} #{@sort_methods[name.to_sym]}")
      end
    end
  end

end