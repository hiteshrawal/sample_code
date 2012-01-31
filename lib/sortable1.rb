module ActsAsSortable
module ClassMethod
 def self.included(base)
  base.class_eval do
  #alias_method_chain :method_missing, :sortable
  #define_method(:sortable)
  end
 end
end

module Sortable
 include ClassMethod
 def sortable(options={})
  puts "sorting apply..."
  puts "klass #{self.class.name}"
  puts self.name
 end
end
end

ActiveRecord::Base.extend ActsAsSortable::Sortable

