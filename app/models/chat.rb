class Chat < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  before_create :generate_uid
  scope :with_user, ->(user_id) { includes(:from, :to).where("from_id = ? or to_id = ?", user_id, user_id)}

  private
    def generate_uid
      begin
        self.uid = SecureRandom.hex(5)
      end while Chat.exists?(uid: self.uid)
    end
end
