require "application_system_test_case"

class SessionAccessTest < ApplicationSystemTestCase
  test "visitor can access the sign-in screen" do
    visit new_session_path

    assert_text "Entrar na conta"
  end
end
