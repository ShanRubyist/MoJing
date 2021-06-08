class UserRssShip < ApplicationRecord
  belongs_to :user
  belongs_to :probe_setting

  validates :user_id, presence: true
  # validates :probe_setting_id, presence: true
end
