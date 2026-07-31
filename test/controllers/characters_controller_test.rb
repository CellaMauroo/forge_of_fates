require "test_helper"

class CharactersControllerTest < ActionDispatch::IntegrationTest
  test "requires authentication" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "shows the characters dashboard for an authenticated user" do
    sign_in_as(users(:one))

    get root_path

    assert_response :success
    assert_select "h1", text: "One."
    assert_select "h2", text: "Meus personagens"
    assert_select "a[href='/characters/wizard/race']", text: /Criar personagem/
  end
end
