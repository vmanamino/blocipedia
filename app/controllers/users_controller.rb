class UsersController < ApplicationController
  def show
    
  end
  
  def update
    @user = current_user
    @user.role = 'standard'
  end
end
