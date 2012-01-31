class AddCounterCacheToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :comments_count, :integer, :default => 0
    User.find_each do |user|
      user.update_attribute(:comments_count, user.comments.length)
      user.save
    end
  end

  def self.down
    remove_column :users, :comments_count
  end
end
