# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#
class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true 
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  has_many :cats,
  foreign_key: :user_id,
  class_name: :Cat 

  has_many :cat_rental_requests,
  foreign_key: :user_id,
  class_name: :CatRentalRequest

  def owns_cat?(cat)
    cat.user_id == self.id
  end

  attr_reader :password 

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return user if user && BCrypt::Password.new(user.password_digest).is_password?(password)
    nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def password=(password)
    @password = password 
    self.password_digest = BCrypt::Password.create(password)
  end
end
