# encoding: UTF-8
class Friendship < ActiveRecord::Base
  # Datenbankbeziehungen
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  
  # Validierungen
  validates_presence_of :user_id, :friend_id
  
  # Gibt den Wert wahr wieder falls die Benutzer Freunde sind
  def self.exists?(user, friend)
    not find_by_user_id_and_friend_id(user, friend).nil?
  end
  
  # Erstellt eine Freundesanfrage
  def self.request(user, friend)
    unless user == friend or Friendship.exists?(user, friend)
      transaction do
        create(:user => user, :friend => friend, :status => 'pending')
        create(:user => friend, :friend => user, :status => 'requested')
      end
    end
  end
  
  # Eine freundesanfrage akzeptieren
  def self.accept(user, friend)
    transaction do
      accepted_at = Time.now
      accept_one_side(user, friend, accepted_at)
      accept_one_side(friend, user, accepted_at)
    end
  end
  
  # Löscht eine Freundschaft oder bricht eine Freundesanfrage ab
  def self.breakup(user, friend)
    transaction do
      destroy(find_by_user_id_and_friend_id(user, friend))
      destroy(find_by_user_id_and_friend_id(friend, user))
    end
  end
  
  private
  
  # Erneuert die Datenbank bei angenommener Freundschaftsanfrage
  def self.accept_one_side(user, friend, accepted_at)
    request = find_by_user_id_and_friend_id(user, friend)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.save!
  end
end