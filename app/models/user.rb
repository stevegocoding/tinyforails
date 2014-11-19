class User < ActiveRecord::Base
  
  include Gravtastic
  gravtastic secure: true, default: 'wavatar', rating: 'G', size: 48
  mount_uploader :avatar, AvatarUploader
  
  has_secure_password
  
  validates :username, uniqueness: {case_sensitive: false}, presence: true, format: { with: /\A[a-z0-9][a-z0-9-]*\z/i }
  validates :name, presence: true
  validates :email, uniqueness: {case_sensitive: false}, presence: true, format: { with: /\A([^@\s]+)@((?:[a-z0-9-]+\.)+[a-z]{2,})\z/i }
  
  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_tokena(token)
    user = find_by_id(token.split('$').first)
    (user && Rack::Utils.secure_compare(user.remember_token, token)) ? user : nil
  end
  
  
end
