module SystemAdmin
  class UsersController < AdminController
    before_action :set_user, only: %i[edit update destroy]

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to(users_path, notice: t("users.create.success"))
      else
        render(:new, status: :unprocessable_entity)
      end
    end

    def update
      if @user.update(user_params)
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
      params.require(:user).permit(:email)
    end
  end
end
