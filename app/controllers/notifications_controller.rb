class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :update, :edit, :destroy]
  before_action :current_user?, only: [:edit, :update]
  before_action :current_user_or_admin?, only: :destroy
  before_action :admin_user, only: :admin
  include SessionsHelper
  require "#{Rails.root}/app/models/notification.rb"

  def new
    @notification = Notification.new()
  end

  def admin
    @notifications = Notification.all
  end

  def index
    @current_user = current_user
    @notifcations = Notification.where(email: @current_user.email)
  end

  def create
    @notification = Notification.new(notification_params)
    @current_user = current_user
    @notification.email = @current_user.email
    @notification.user_id = @current_user.id
    if `python3 form_valid?.py "#{@notification.month}" "#{@notification.day}" "#{@notification.hour}" "#{@notification.minute}" "#{@notification.train}" "#{@notification.dep_stn}" "#{@notification.arr_stn}"`=="1\n"
      if @notification.save
        flash[:success] = "通知の登録に成功しました"
        redirect_to notifications_index_path
      else
        flash[:danger] = "登録内容の保存に失敗しました。"
        redirect_to notifications_path
      end
    else
      flash[:danger] = "入力内容が不正です。"
      redirect_to notifications_path
    end
  end

  def show
    @notification = Notification.find_by(id: params[:id])
  end

  def destroy
    Notification.find_by(id: params[:id]).destroy
    flash[:success] = "通知設定を消去しました"
    redirect_to notifications_index_path
  end

  def edit
    @notification = Notification.find(params[:id])
  end

  def update
    @notification = Notification.find(params[:id])
    if notification_params[:token] == ""
      flash[:danger] = "トークンを入力してください"
      render "edit"
    else
      if @notification.update_attributes(notification_params)
        flash[:success] = "通知登録の更新に成功しました。"
        redirect_to notifications_index_path
      else
        flash[:danger] = "入力内容が不正です。"
        redirect_to notifications_path
      end
    end
  end

  private
  def notification_params
      params.require(:notification).permit(:token, :month, :day, :train,
                                            :hour, :minute, :dep_stn, :arr_stn)
  end
  #ログインしているかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_path
    end
  end
  #ログインユーザの確認
  def current_user?
    @notification = Notification.find(params[:id])
    unless (@notification.email == @current_user.email)
      flash[:danger] = "アクセスが不正です"
      redirect_to notifications_index_path
    end
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  #管理者かどうかを判定(True or False)
  def admin_user?
    current_user.admin?
  end

  def current_user_or_admin?
    @notification = Notification.find(params[:id])
    redirect_to(notifications_index_path) unless ((admin_user?) || (@notification.email == @current_user.email))
  end
end
