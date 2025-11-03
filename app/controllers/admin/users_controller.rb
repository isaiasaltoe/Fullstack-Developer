module Admin
  class UsersController < Admin::ApplicationController
    
    def scoped_resource
      User.all
    end

    def resource_params
      params.require(:user).permit(:username, :role, :password, :password_confirmation, :avatar_image)
    end

    def update_resource(resource, attributes)
      attrs = attributes.first
      if attrs[:password].blank? && attrs[:password_confirmation].blank?
        resource.update_without_password(attrs.except(:password, :password_confirmation))
      else
        resource.update(attrs)
      end
    end

    def create
      @user = User.new(resource_params)
      if @user.save
        redirect_to admin_user_path(@user), notice: translate_with_resource("create.success")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def import_form; end

    def import
      if params[:file].blank?
        redirect_to import_form_admin_users_path, alert: "Por favor, envie um arquivo."
        return
      end

      spreadsheet = Roo::Spreadsheet.open(params[:file].path)
      header = spreadsheet.row(1)

      success_count = 0
      errors = []

      (2..spreadsheet.last_row).each do |i|
        row_data = Hash[[header, spreadsheet.row(i)].transpose]
        user = User.new(username: row_data["username"], password: row_data["password"])
        if user.save
          success_count += 1
        else
          errors << "Linha #{i}: #{user.errors.full_messages.join(', ')}"
          Rails.logger.error(errors.last)
        end
      end

      notice = "Importação concluída! #{success_count} usuários criados."
      notice += " Erros: #{errors.join('; ')}" if errors.any?
      redirect_to admin_users_path, notice: notice
    end
  end
end
