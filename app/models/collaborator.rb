class Collaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  validates :user, presence: true
  validates :wiki, presence: true

  def name
    user = User.where(id: self.user_id).first
    user.name
  end
end
