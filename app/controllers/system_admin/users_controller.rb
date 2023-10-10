module SystemAdmin
  class UsersController < AdminController
    before_action :set_user, only: %i[edit update destroy]

    def index
      @users = User.all
    end

    def new
      @user = User.new
      @roles = Role.all
    end

    def edit
      @roles = Role.all
    end

    def create
      @user = User.new(user_params)
      @user.roles = []
      params[:user][:role_ids].each do |role_id|
        @user.add_role(Role.find(role_id).name) if role_id.present?
      end

      if @user.save
        redirect_to(users_path, notice: t("users.create.success"))
      else
        render(:new, status: :unprocessable_entity)
      end
    end

    def update
      if @user.update(user_params)
        @user.roles = []
        params[:user][:role_ids].each do |role_id|
          @user.add_role(Role.find(role_id).name) if role_id.present?
        end
        @user.save
        redirect_to(users_path, notice: t("users.update.success"))
      else
        render(:edit, status: :unprocessable_entity)
      end
    end

    def destroy
      @user.destroy

      redirect_to(users_path, notice: t("users.destroy.success"))
    end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :role_ids)
    end
  end
end
