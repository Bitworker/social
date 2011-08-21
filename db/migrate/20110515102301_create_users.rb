# encoding: UTF-8
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
			t.string "screen_name"
			t.string "email"
			t.string "password"
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end