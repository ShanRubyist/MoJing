class SQLPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def sql?
    user.admin?
  end
end
