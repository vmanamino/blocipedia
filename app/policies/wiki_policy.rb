class WikiPolicy < ApplicationPolicy
  def index?
    true
  end
  def show?
    user.present? && (user.premium? || user.admin?)
  end

  def destroy?
    user.present? && (record.user == user || user.admin?)
  end
end
