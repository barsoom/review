defmodule Review.ApiControllerTest do
  use Review.ConnCase
  import Review.Factory

  test "unreviewed_commit_stats denies users with an invalid secret key" do
    conn = build_conn()
      |> get("/api/v1/unreviewed_commit_stats?secret=invalid_secret")

    assert response(conn, 403) =~ "Denied (probably an invalid key?)"
  end

  test "unreviewed_commit_stats returns data when there are no commits" do
    conn = build_conn()
      |> get("/api/v1/unreviewed_commit_stats?secret=api_secret")

    assert json_response(conn, 200) == %{
      "count" => 0,
      "oldest_age_in_seconds" => nil
    }
  end

  test "unreviewed_commit_stats returns data when there is commits" do
    insert(:commit)

    conn = build_conn()
      |> get("/api/v1/unreviewed_commit_stats?secret=api_secret")

    assert json_response(conn, 200) == %{
      "count" => 1,
      "oldest_age_in_seconds" => 0
    }
  end
end

