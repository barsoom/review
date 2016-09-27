defmodule Review.GithubControllerTest do
  use Review.ConnCase

  test "can handle a ping" do
    conn = build_conn
      |> put_req_header("x-github-event", "ping")
      |> post("/webhooks/github?secret=webhook_secret", %{ zen: "Yo.", hook_id: 123 })

    assert text_response(conn, 200) =~ "pong"
  end

  test "requires a valid key" do
    conn = build_conn
      |> put_req_header("x-github-event", "ping")
      |> post("/webhooks/github?secret=invalid", %{ zen: "Yo.", hook_id: 123 })

    assert response(conn, 403) =~ "Denied (probably an invalid key?)"
  end
end
