class Wiki < ActiveRecord::Base
  belongs_to :user

  validates :title, length: { minimum: 5, maximum: 255 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true
  
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
end
