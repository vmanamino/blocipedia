class WikiPolicy < ApplicationPolicy
  def index?
    true
  end
  def show?
    record.private == false || (user.admin? || record.user == user)
  end
  def update?
    user.present? && (record.private == false || (user.admin? || record.user == user))
  end
  def destroy?
    user.present? && (record.user == user || user.admin?)
  end
end
