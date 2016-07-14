class UsersController < ApplicationController
  before_action :confirm_user, only:[:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "Your profile is changed!"
      redirect_to @user
    else
      render 'edit'
    end
  end 
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :region, :profile, :password,
                                 :password_confirmation)
  end
  
  def confirm_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path
    end
  end
end
