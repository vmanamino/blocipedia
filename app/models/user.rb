class User < ActiveRecord::Base
  include ActiveModel::Dirty
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :wikis
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

  private

  def defaults
    self.role ||= 'standard'
  end

  def downgrade_status
    return unless self.role_changed?(from: 'premium', to: 'standard')
    wikis.update_all private: false
  end
end
