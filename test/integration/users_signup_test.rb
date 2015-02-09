require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    this_fail_thrown_errors_count = 4
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div#error_explanation .alert', "The form contains #{this_fail_thrown_errors_count} errors."
    assert_select 'div#error_explanation ul li'
    assert_select 'div#error_explanation ul li', this_fail_thrown_errors_count
    assert_select 'div.field_with_errors'
    assert_not flash[:success]
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'
    assert flash[:success]
    assert_select 'div.alert-success', 'Welcome to the Sample App!'
  end
end
