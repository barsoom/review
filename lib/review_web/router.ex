defmodule ReviewWeb.Router do
  use Review.Web, :router
  use Honeybadger.Plug

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1", ReviewWeb do
    pipe_through(:api)

    get("/unreviewed_commit_stats", ApiController, :unreviewed_commit_stats)
  end

  scope "/webhooks", ReviewWeb do
    pipe_through(:api)

    post("/github", GithubController, :create)
  end

  scope "/", ReviewWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/:page", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", Review do
  #   pipe_through :api
  # end
end
