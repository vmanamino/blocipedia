class Wiki < ActiveRecord::Base
  belongs_to :user

  validates :title, length: { minimum: 5, maximum: 255 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true

  def self.visible_to(user)
    if user
      if user.role == 'admin'
        Wiki.all
      else
        Wiki.where('user_id=? OR private=?', user.id, false)
      end
    else
      Wiki.where(private: false)
    end
  end

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
end
