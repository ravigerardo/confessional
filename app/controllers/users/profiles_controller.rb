class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
  end

  def edit
    if current_user.update(profile_params)
      flash[:notice] = 'Success.'
      redirect_to root_path
    else
      flash[:error] = 'Invalid values.'
      redirect_to edit_user_registration_path
    end
  end

  private
    def profile_params
      params.require(:user).permit(:avatar, :name, :username, :about)
    end
end
