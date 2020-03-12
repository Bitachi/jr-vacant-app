require 'test_helper'

class NotificationsCreateTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "valid register information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get "/notifications"
    assert_difference "Notification.count", 1 do
      post "/notifications", params: { notification: { token: "SampleToken",
                                          dep_stn: "東京",
                                          arr_stn: "岡山",
                                          hour: "00",
                                          minute: "00",
                                          train: "在来線列車",
                                          month: "04",
                                          day: "01"}}
    end
    follow_redirect!
    assert_template root_path
    assert_not flash.nil? #フラッシュのテスト
    assert_not Notification.last.salt.nil? #saltが保存されているかテスト
  end
  #無効な通知登録（トークン未入力、指定席データは有効）
  test "invalid register information(no token)" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get "/notifications"
    assert_no_difference "Notification.count" do
      post "/notifications", params: { notification: { token: "",
                                          dep_stn: "東京",
                                          arr_stn: "岡山",
                                          hour: "22",
                                          minute: "00",
                                          train: "在来線列車",
                                          month: "03",
                                          day: "30"}}
    end
    assert_redirected_to notifications_path
  end

  #無効な通知登録（トークン入力、指定席データ無効）
  test "invalid register information(invalid seat)" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get "/notifications"
    assert_no_difference "Notification.count" do
      post "/notifications", params: { notification: { token: "SampleToken",
                                          dep_stn: "東京",
                                          arr_stn: "小倉",
                                          hour: "22",
                                          minute: "00",
                                          train: "在来線列車",
                                          month: "02",
                                          day: "30"}}
    end
    assert_redirected_to notifications_path
  end
end
