class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  PAGE_SIZE = 10

  def new
    @user = User.new
  end

  def index
    #Show all users to admin users, otherwise show only those that are activated
    if current_user.admin?
      @users = User.paginate(page: params[:page], :per_page => PAGE_SIZE)
    else
      @users = User.where(activated: true).paginate(page: params[:page], :per_page => PAGE_SIZE)
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email()
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page],
                                      :per_page => PAGE_SIZE)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page],
                                      :per_page => PAGE_SIZE)
    render 'show_follow'
  end

  #Start of private methods
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end



  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
