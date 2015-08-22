class CollaboratorPolicy < ApplicationPolicy
  def show?
    false
  end

  def create?
    user.present? && (user.admin? || user.premium?)
  end

  def destroy?
    user.present? && (user.admin? || record.wiki.user == user)
  end
end
