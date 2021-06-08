class RssInfo < ApplicationRecord
  belongs_to :probe_setting

  validates :probe_setting_id, uniqueness: true, presence: true
end
