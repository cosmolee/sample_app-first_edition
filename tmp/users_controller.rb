class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]
  before_filter :check_new,    :only => [:create, :new] #Signed-in users have no reason to access new and create actions.


  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ''
      @user.password_confirmation = ''
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end



  def destroy
c_name = params[:id].class 
puts "filler..   "
puts c_name
#.to_s
#    if current_user.id == params[:id].to_s.to_i 
      redirect_to(users_path)
#      flash[:error] = "You may not delete yourself!"
#    else
#      User.find(params[:id]).destroy
#      flash[:success] = "User destroyed."
#      redirect_to users_path
#    end
  end



  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def check_new
      redirect_to(root_path) if signed_in?
    end


end
