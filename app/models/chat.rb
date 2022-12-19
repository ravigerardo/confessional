class Chat < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  has_many :messages
  before_create :generate_uid

  def self.for_home(user_id)
    self
      .joins("JOIN users AS from_user ON from_user.id = chats.from_id")
      .joins("JOIN users AS to_user ON to_user.id = chats.to_id")
      .joins("JOIN messages ON messages.id = (SELECT id FROM messages WHERE messages.chat_id = chats.id ORDER BY created_at DESC LIMIT 1)")
      .where("from_id = ? or to_id = ?", user_id, user_id)
      .select("chats.*, from_user.username AS from_username, to_user.username AS to_username, messages.user_id AS user_id_last_message")
      .order('messages.created_at DESC')
  end

  private
    def generate_uid
      begin
        self.uid = SecureRandom.hex(5)
      end while Chat.exists?(uid: self.uid)
    end
end
