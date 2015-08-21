class User < ActiveRecord::Base
  include ActiveModel::Dirty
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :wikis
  has_many :collaborators

  validates :role, presence: true
  after_initialize :defaults, if: :new_record?
  after_update :downgrade_status

  def admin?
    role == 'admin'
  end

  def standard?
    role == 'standard'
  end

  def premium?
    role == 'premium'
  end

  def wikis_collaborator
    collaboration_wikis = []
    collaborators = Collaborator.includes(:wiki).where(user_id: self).all
    collaborators.each do |collaborator|
      collaboration_wikis.push(collaborator.wiki)
    end
    collaboration_wikis
  end

  def added_to(wiki)
    collaborators.where(user_id: self, wiki_id: wiki.id).first
  end

  def exclude
    User.where.not('id=? OR role=?', self, 'admin')
  end

  private

  def defaults
    self.role ||= 'standard'
  end

  def downgrade_status
    return unless self.role_changed?(from: 'premium', to: 'standard')
    wikis.update_all private: false
  end
end
