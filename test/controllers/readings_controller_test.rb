require "test_helper"

class ReadingsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get readings_create_url
    assert_response :success
  end
end
