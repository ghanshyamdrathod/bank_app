require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  api_fixtures

  setup do
    sign_in users(:normal_user)
    @transaction = transactions(:credit)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end