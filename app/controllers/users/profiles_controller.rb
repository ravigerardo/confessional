class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[ edit ]

  def show
    @user = User.find_by(username: params[:username]) or not_found
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
