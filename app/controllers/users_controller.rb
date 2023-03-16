class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def index
    @users = User.get_all.paginate(page: params[:page], per_page: 3)
  end
  
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:notice] = "User not found"
    end
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:info] = t(".check_email_activation_noti")
      redirect_to @user
    else
      render :new
    end
  end
end
