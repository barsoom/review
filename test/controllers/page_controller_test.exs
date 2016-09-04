defmodule Exremit.PageControllerTest do
  use Exremit.ConnCase

  test "allows you to see the page with the correct token" do
    conn = get build_conn(), "/", %{ auth_key: "secret" }
    assert html_response(conn, 200) =~ "Exremit"
  end

  test "disallows access for invalid tokens" do
    conn = get build_conn(), "/", %{ auth_key: "invalid" }
    assert response(conn, 403) =~ "Denied (probably an invalid auth_key?)"
  end
end
