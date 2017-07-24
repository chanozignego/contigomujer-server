class TownPolicy < ApplicationPolicy

  def index?
    user.present? && user.superadmin?
  end

  def show?
    user.present? && scope.where(id: record.id).exists? && user.superadmin?
  end

  def create?
    user.present? && user.superadmin?
  end

  def update?
    user.present? && record.present? && user.superadmin?
  end

  def destroy?
    user.present? && record.present? && user.superadmin?
  end

  def self.show_in_sidebar? user
    user.present? && user.superadmin?
  end 

end