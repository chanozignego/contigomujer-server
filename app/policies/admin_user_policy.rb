class AdminUserPolicy < ApplicationPolicy

  def show?
    ( user.present? && scope.where(id: record.id).exists? ) && ( user.superadmin? || record.town == user.town )
  end

  def update?
    ( user.present? && record.present? ) && ( user.superadmin? || record.town == user.town )
  end

  def destroy?
    ( user.present? && record.present? ) && ( user.superadmin? || record.town == user.town )
  end

  class Scope < ApplicationPolicy::Scope
    def resolve_for_non_admins
      scope.where(town: user.town)
    end
  end

end