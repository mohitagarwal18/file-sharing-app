class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :authenticate_user,   only: [:edit, :update]
  def new
    unless logged_in?
      @user  = User.new
    else
      redirect_to '/'
    end
  end

  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to '/dashboard'
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)   
    if @user.save
      flash[:success] = "Welcome to the file sharing app!"
      log_in @user
      redirect_to '/dashboard'
    else
      render 'new'
    end
  
  end
  
  def edit
    @user = User.find(params[:id])
  end

end

private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
  def authenticate_user
    user = User.find_by_id(params[:id])
    unless current_user?(user)
      flash[:danger]  = "Not Authorised To Perform The Request."
      redirect_to(root_url) 
    end
  end
  
