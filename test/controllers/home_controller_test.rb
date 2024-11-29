require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get mypage" do
    get home_mypage_url
    assert_response :success
  end

end
