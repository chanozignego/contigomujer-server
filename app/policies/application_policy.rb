class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.present?
  end

  def show?
    user.present? && scope.where(id: record.id).exists?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present? && record.present?
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && record.present?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def self.show_in_sidebar? user
    user.present?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.superadmin?
        scope.all
      else
        resolve_for_non_admins()
      end
    end

    def resolve_for_non_admins
      scope.all
    end
  end
end
