# encoding: UTF-8
class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
    	t.integer :user_id, :null => false
			t.text :bio
			t.text :faehigkeiten
			t.text :schulen
			t.text :firmen
			t.text :musik
			t.text :filme
			t.text :tv
			t.text :magazine
			t.text :buecher
      t.timestamps
    end
  end

  def self.down
    drop_table :faqs
  end
end
