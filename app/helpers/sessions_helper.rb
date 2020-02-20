module SessionsHelper
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  #現在ログイン中のユーザーを探す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  #ユーザーがログインしていればtrue、そうでなければfalseを返す
  def logged_in?
    !current_user.nil?
  end

  #現在のユーザをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
