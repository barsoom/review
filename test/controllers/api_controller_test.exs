defmodule Review.ApiControllerTest do
  use Review.ConnCase
  import Review.Factory

  test "unreviewed_commit_stats works" do
    conn = build_conn
      |> get("/api/v1/unreviewed_commit_stats?secret=api_secret")

    assert json_response(conn, 200) == %{
      "count" => 0,
      "oldest_age_in_seconds" => nil
    }

    insert(:commit)

    conn = build_conn
      |> get("/api/v1/unreviewed_commit_stats?secret=api_secret")

    assert json_response(conn, 200) == %{
      "count" => 1,
      "oldest_age_in_seconds" => 0
    }
  end
end

