class AddCron < ActiveRecord::Migration

    def self.up
      create_table :crons do |t|
        t.string :mail_ids
        t.string :terms

        t.timestamps
      end
    end

    def self.down
      drop_table :crons
    end
  end
