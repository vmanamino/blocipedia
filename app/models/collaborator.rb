class Collaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  validates :user, presence: true
  validates :wiki, presence: true
end
