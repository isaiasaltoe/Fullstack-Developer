class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Active Storage
  

  validates :username, presence: true, uniqueness: true
  validates :role, inclusion: { in: %w[user admin] }

  has_one_attached :avatar_image

  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= 'user'
  end

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
