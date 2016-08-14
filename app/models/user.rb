# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  uuid                   :string(255)
#  roles                  :string(255)
#  visible                :boolean          default(TRUE)
#  auth_token             :string(255)
#  name                   :string(255)
#  mobile                 :string(255)
#

class User < ActiveRecord::Base
  SALT = "foobar-su"
  validates :mobile, presence: true
  validates :password, presence: true, on: :create

  include UUID
  after_create do
    self.update_column :auth_token, SecureRandom.hex(16)
  end

  attr_accessor :password

  has_many :entities

  scope :normal_user, -> { where( "roles LIKE '%user%'" ) }
  scope :admin, -> { where( "roles LIKE '%admin%'" ) }

  before_create do |u|
    u.roles = 'user'
  end

  def user?
    self.roles =~ Regexp.new('user')
  end

  def admin?
    true
  end

  def make_admin!
    self.roles += ",admin"
    self.save!
  end

  def roles_in_words
    [self.user? ? "注册用户" : nil,  self.admin? ? "管理员" : nil].compact
  end

  def password=(pass)
    self.encrypted_password = encrypt_password(pass)
  end

  def password_valid?(pass)
    self.encrypted_password == encrypt_password(pass)
  end

  def encrypt_password(pass)
    Digest::SHA1.hexdigest(SALT + pass)
  end

  def identity
    self.name || self.mobile || "我"
  end
end

