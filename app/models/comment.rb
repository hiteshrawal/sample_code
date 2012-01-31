require '/home/hitesh/modules/sortable/sortable1'
class Comment < ActiveRecord::Base
  belongs_to :user , :counter_cache => true
  named_scope :for_user, lambda{|arg| {:conditions => {:user_id => 2}, :order => arg }}
  #sortable

  # class method
  def self.full_name
     "#{self.user_id}"
  end

  # instance method
  def my_name
     "#{user_id}"
  end

end
