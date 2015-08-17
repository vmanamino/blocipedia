class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :collaborators
  has_many :collaborators

  validates :title, length: { minimum: 5, maximum: 255 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  def user_collaborators
    users = []
    collaborators = Collaborator.includes(:user).where(wiki_id: self).all
    collaborators.each do |collaborator|
      users.push(collaborator.user)
    end
    users
  end

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
end
