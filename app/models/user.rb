# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string
#  email              :string           default("")
#  encrypted_password :string           default("")
#

class User < ActiveRecord::Base
  extend Rolify
  rolify

  attr_accessor :password

  has_many :dashboards, dependent: :destroy do
    def default
      where(default: true).first
    end
  end

  validates :name, presence: true, uniqueness: true
  validates :email, email_format: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 4}, on: :create
  validates :password, presence: true, length: {minimum: 4}, allow_blank: true, on: :update

  before_save :hash_password
  before_validation :email_to_lowercase

  scope :search, -> (q) { where('name like ? or email like ?', "%#{q}%", "%#{q}%") }

  def to_s
    %Q{"#{name}" <#{email}>}
  end

  def authenticate! password
    unless BCrypt::Password.new(encrypted_password) == password
      raise BCrypt::Errors::InvalidSecret
    end
  end

  private

  def hash_password
    self.encrypted_password = BCrypt::Password.create password if password.present?
  end

  def email_to_lowercase
    self.email = self.email.downcase
  end
end
