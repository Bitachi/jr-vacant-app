class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :admin_on, :admin_off]
  include SessionsHelper
  def new
  end

  def admin_on
    @user = User.find(params[:id])
    @user.admin = true
    @user.save
    redirect_to users_path
  end


  def admin_off
    @user = User.find(params[:id])
    @user.admin = false
    @user.save
    redirect_to users_path
  end


  def index
    @users = User.paginate(page: params[:page])
  end


  def show
    @user = User.find_by(id: params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "JR空席通知アプリへようこそ!"
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_notification_email
  end

  def update
    @user = User.find(params[:id])
    old_email = @user.email
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザ設定が更新されました"
      if old_email != @user.email #古いemailと新しいemailに差分がある場合
        public_method(:edit_notification_email).super_method.call
      end
      redirect_to @user
    else
      render "edit"
    end
  end


  def destroy
    public_method(:index).super_method.call
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーが削除されました"
    redirect_to users_url
  end



  private

    def user_params
        params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end

    #ログインしているかどうか確認
    #def logged_in_user
    #  unless logged_in?
    #    flash[:danger] = "ログインしてください"
    #    redirect_to login_path
    #  end
    #end

    #ログインしているユーザと一致しているか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
