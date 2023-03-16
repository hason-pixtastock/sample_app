class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 3)
  end
  
  def show
    user_id = params[:id]
    @user = User.find_by(id: user_id)
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

  def edit
    @user = User.find(params[:id])
  end

  def update 
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        flash[:success] = t(".update_user_noti")
        redirect_to @user
      else
        render :edit
      end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t(".destroy_user_noti")
    redirect_to users_url
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
      store_location
      flash[:danger] = t("log_in_required_noti")
      redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
