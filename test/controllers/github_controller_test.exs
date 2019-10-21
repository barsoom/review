defmodule Review.GithubControllerTest do
  use ReviewWeb.ConnCase
  use Phoenix.ChannelTest

  test "can handle a ping" do
    conn =
      build_conn
      |> put_req_header("x-github-event", "ping")
      |> post("/webhooks/github?secret=webhook_secret", %{zen: "Yo.", hook_id: 123})

    assert text_response(conn, 200) =~ "pong"
  end

  test "can handle a commit_comment update" do
    {:ok, _, _socket} =
      socket("", %{})
      |> subscribe_and_join(Review.ReviewChannel, "review")

    conn =
      build_conn
      |> put_req_header("x-github-event", "commit_comment")
      |> post("/webhooks/github?secret=webhook_secret", %{
        comment: Jason.decode!(Review.Factory.comment_payload())
      })

    assert text_response(conn, 200) =~ "ok"

    assert_broadcast("new_or_updated_comment", %{})

    comment = Review.Repo.comments() |> Review.Repo.one()
    assert comment.commit_sha == "2be829b9163897e8bb57ceea9709a5d5e61faee1"
  end

  test "can handle a push update" do
    {:ok, _, _socket} =
      socket("", %{})
      |> subscribe_and_join(Review.ReviewChannel, "review")

    conn =
      build_conn
      |> put_req_header("x-github-event", "push")
      |> post(
        "/webhooks/github?secret=webhook_secret",
        Jason.decode!(Review.Factory.push_payload())
      )

    assert text_response(conn, 200) =~ "ok"

    assert_broadcast("new_or_updated_commit", %{})

    commit = Review.Repo.commits() |> Review.Repo.one()
    assert commit.sha == "c5472c5276f564621afe4b56b14f50e7c298dff9"
    assert Review.CommitSerializer.serialize(commit).repository == "gridlook"
  end

  test "can handle a push update caused by a pair commit" do
    conn =
      build_conn
      |> put_req_header("x-github-event", "push")
      |> post(
        "/webhooks/github?secret=webhook_secret",
        Jason.decode!(Review.Factory.pair_commit_push_payload())
      )

    assert text_response(conn, 200) =~ "ok"
  end

  test "ignores non-master commits in push updates" do
    data =
      Jason.decode!(Review.Factory.push_payload())
      |> Map.put("ref", "refs/heads/lab")

    conn =
      build_conn
      |> put_req_header("x-github-event", "push")
      |> post("/webhooks/github?secret=webhook_secret", data)

    assert text_response(conn, 200) =~ "ok"

    commit_count = Review.Repo.commits() |> Review.Repo.all() |> Enum.count()
    assert commit_count == 0
  end

  test "requires a valid key" do
    conn =
      build_conn
      |> put_req_header("x-github-event", "ping")
      |> post("/webhooks/github?secret=invalid", %{zen: "Yo.", hook_id: 123})

    assert response(conn, 403) =~ "Denied (probably an invalid key?)"
  end
end
