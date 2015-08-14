class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    wikis = @user.wikis
    @wikis_private = wikis.where(private: true).all
    @wikis_public = wikis.where(private: false).all
  end

  def update # rubocop:disable Metrics/AbcSize
    if current_user.update_attributes(params.require(:user).permit(:role))
      flash[:notice] = 'Your account was downgraded'
      redirect_to user_path(current_user)
    else
      flash[:error] = 'Your account failed to downgrade'
      redirect_to user_path(current_user)
    end
  end
end
