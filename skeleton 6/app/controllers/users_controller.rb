class UsersController < ApplicationController

  # before_action :require_no_user!
  before_action :require_logged_out, only: [:new, :create, :edit]
  # before_action :require_logged_in, only: [:edit, :update, :index, :show, :destroy]

  # def index
  #   @users = User.all
  #   render :index
  # end

  # def show
  #   @user = User.find(params[:id])
  #   render :show
  # end

  def new
    @user = User.new
    render :new
  end

  def create
    debugger
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      redirect_to cats_url 
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    render :edit
  end

  # def update
  #   @user = User.find_by(id: params[:id])
  #   if @user.update_attributes(user_params)
  #     redirect_to user_url(@user)
  #   else
  #     flash.now[:errors] = @user.errors.full_messages
  #     render :edit
  #   end
  # end

  # def destroy
  #   @user = User.find_by(id: params[:id])
  #   @user.destroy 
  #   redirect_to users_url
  # end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
