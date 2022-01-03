class UsersController < ApplicationController
 # render signup form
  def new
  end

  # receiving the form info and creating a user with the form's parameters
  def create
    user = User.new(user_params)
    if user.save
      puts user
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
