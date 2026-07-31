require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "derives a display name and initials from the email prefix" do
    user = User.new(email_address: "mauro.silva@forge-of-fates.local")

    assert_equal("Mauro Silva", user.display_name)
    assert_equal("MS", user.initials)
  end
end
