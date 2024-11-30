require 'test_helper'

class LivePaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get live_payments_create_url
    assert_response :success
  end

end
