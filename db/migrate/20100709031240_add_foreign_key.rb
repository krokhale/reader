class AddForeignKey < ActiveRecord::Migration
  def self.up
    add_column :terms, :account_id, :integer
  end

  def self.down
    remove_column :terms, :account_id
  end
end
