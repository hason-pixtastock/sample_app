class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  def index 
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:notice] = "User not found"
    end
  end
  
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = "Successfully created user."
      redirect_to @user   #same as user_url(@user)
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # log_in @user
      # flash[:success] = "Successfully created user."
      # redirect_to @user   #same as user_url(@user)
    else
      render :new
    end
  end
end