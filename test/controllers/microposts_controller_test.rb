require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  #他のユーザは投稿を消せない
  test "should not delete when loggined as another user" do
    log_in_as(@other_user)
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
  end
end
