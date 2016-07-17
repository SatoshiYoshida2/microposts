class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:info] = t('flash.session_create_login', user_name: @user.name)#"logged in as #{@user.name}"
      redirect_to @user
    else
      flash[:danger] = t('flash.session_create_invalid')
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
