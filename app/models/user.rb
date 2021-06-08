class User < ApplicationRecord
  has_many :user_rss_ships
  has_many :probe_settings, :through => :user_rss_ships

  has_many :pdd_web_spider_settings

  has_many :user_rss_feed_ships
  has_many :rss_feeds, :through => :user_rss_feed_ships

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, :omniauth_providers => [:weibo]

  def admin?
    self.role == 'admin'
  end
end
