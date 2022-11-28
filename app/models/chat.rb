class Chat < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  before_create :generate_uid

  def self.with_user(user_id)
    self
      .joins("JOIN users AS from_user ON from_user.id = chats.from_id")
      .joins("JOIN users AS to_user ON to_user.id = chats.to_id")
      .where("from_id = ? or to_id = ?", user_id, user_id)
      .select("chats.*, from_user.username AS from_username, to_user.username AS to_username")
  end

  private
    def generate_uid
      begin
        self.uid = SecureRandom.hex(5)
      end while Chat.exists?(uid: self.uid)
    end
end
