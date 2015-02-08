# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :time
#  remember_created_at    :time
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :time
#  last_sign_in_at        :time
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
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
