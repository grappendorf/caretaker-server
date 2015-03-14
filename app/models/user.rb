# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string           default("")
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :time
#  remember_created_at    :time
#  sign_in_count          :integer          default("0")
#  current_sign_in_at     :time
#  last_sign_in_at        :time
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#

class User < ActiveRecord::Base

  rolify

  has_many :dashboards, dependent: :destroy do
    def default
      where(default: true).first
    end
  end

  validates :name, presence: true, uniqueness: true

  scope :search, -> (q) { where('name like ? or email like ?', "%#{q}%", "%#{q}%") }

  def to_s
    %Q{"#{name}" <#{email}>}
  end

  # Devise

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable,
  # :lockable, and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

end
