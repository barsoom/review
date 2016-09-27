defmodule Review.GithubControllerTest do
  use Review.ConnCase

  test "can handle a ping" do
    conn = build_conn
      |> put_req_header("x-github-event", "ping")
      |> post("/webhooks/github?secret=webhook_secret", %{ zen: "Yo.", hook_id: 123 })

    assert text_response(conn, 200) =~ "pong"
  end

  test "can handle a commit_comment update" do
    conn = build_conn
      |> put_req_header("x-github-event", "commit_comment")
      |> post("/webhooks/github?secret=webhook_secret", %{ comment: Review.Factory.comment_payload })

    assert text_response(conn, 200) =~ "ok"

    # todo: test push and persistence

    #comment = Review.Repo.comments |> Review.Repo.one
    #assert comment.commit_sha == "2be829b9163897e8bb57ceea9709a5d5e61faee1"
  end

  test "requires a valid key" do
    conn = build_conn
      |> put_req_header("x-github-event", "ping")
      |> post("/webhooks/github?secret=invalid", %{ zen: "Yo.", hook_id: 123 })

    assert response(conn, 403) =~ "Denied (probably an invalid key?)"
  end
end
