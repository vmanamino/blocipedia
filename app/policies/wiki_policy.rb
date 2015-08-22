class WikiPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.private == false || ((user.admin? || record.user == user) || record.user_collaborators.include?(user))
  end

  def update? # rubocop:disable Metrics/AbcSize
    user.present? && (record.private == false || ((user.admin? || record.user == user) || record.user_collaborators.include?(user))) # rubocop:disable Metrics/LineLength
  end

  def destroy?
    user.present? && (record.user == user || user.admin?)
  end
end
