defmodule Exremit.PageControllerTest do
  use Exremit.ConnCase

  test "allows you to see the page with the correct token" do
    conn = get conn(), "/", %{ auth_key: "secret" }
    assert html_response(conn, 200) =~ "Commits"
  end

  test "disallows access for invalid tokens" do
    conn = get conn(), "/", %{ auth_key: "invalid" }
    assert response(conn, 403) =~ "Denied (probably an invalid auth_key?)"
  end
end
