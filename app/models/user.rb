class User < ApplicationRecord
  has_many :chats, foreign_key: :from_id
  has_rich_text :about
  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_fill: [50, 50]
    attachable.variant :large, resize_to_fill: [250, 250]
  end
  validate :avatar_validation
  validates :name, presence: true
  validates :username, presence: true, format: { with: /\A[a-z0-9_\-]{3,20}\z/}
  validates :username, uniqueness: true
  validates :username, exclusion: { in: %w(users) }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable#, :omniauthable

  def disable!
    self.update(active?: false)
  end

  private
    def avatar_validation
      if avatar.attached?
        if avatar.blob.byte_size > 1500000
          errors[:base] << 'La imagen debe pesar menos de 1 MB.'
        elsif !avatar.blob.content_type.starts_with?('image/')
          errors[:base] << 'Formato de imagen permitido .jpg, .jpeg, .png o .gif'
        end
      end
    end
end
