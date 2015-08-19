class CollaboratorPolicy < ApplicationPolicy
  def create?
    user.present? && (user.admin? || user.premium?)
  end

  def destroy?
    create?
  end
end
