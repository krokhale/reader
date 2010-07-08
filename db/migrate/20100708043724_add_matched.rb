class AddMatched < ActiveRecord::Migration
  
   def self.up
      add_column :messages, :matched, :string
    end

    def self.down
      remove_column :messages, :matched
    end
  end