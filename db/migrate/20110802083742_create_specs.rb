# encoding: UTF-8
class CreateSpecs < ActiveRecord::Migration
  def self.up
    create_table :specs do |t|
			t.integer :user_id, :null => false
			t.string :vorname, :default => ""
			t.string :nachname, :default => ""
			t.string :geschlecht
			t.date 	 :geburtstag
			t.string :arbeit, :default => ""
			t.string :stadt, :default => ""
			t.string :land, :default => ""
			t.string :postleitzahl, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :specs
  end
end
