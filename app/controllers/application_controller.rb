class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def hello
    render html: "hello, world!"
  end


  #    notifications = Notification.where(email: old_email)
  #    notifications.each do |notification|
  #      notification.email = params[:email]
  #      notification.save
  #    end
  #  end

  def edit_notification_email
    notifications = Notification.where(user_id: params[:id])
    if notifications.present?
      email = User.find(params[:id]).email
      notifications.each do |notification|
        notification.update_column(:email, email)
      end
    end
  end

  def index
    email = User.find(params[:id]).email
    notifications = Notification.where(email: email)
    notifications.each do |notification|
      notification.destroy
    end
  end


  private

    def logged_in_user
      unless logged_in?
        #store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
