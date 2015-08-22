class Collaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  validates :user, presence: true
  validates :wiki, presence: true

  def name
    user = User.where(id: user_id).first # rubocop:disable Rails/FindBy
    user.name
  end

  def wiki
    Wiki.where(id: wiki_id).first # rubocop:disable Rails/FindBy
  end
end
