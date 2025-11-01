module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!  # garante login
    before_action :require_admin        # garante que só admins acessem

    private

    def require_admin
      return if current_user.admin?

      flash[:alert] = "Você não tem permissão para acessar essa página."
      redirect_to root_path
    end
  end
end
