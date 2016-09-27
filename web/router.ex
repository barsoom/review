defmodule Review.Router do
  use Review.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/webhooks", Review do
    pipe_through :api

    post "/github", GithubController, :create
  end

  scope "/", Review do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:page", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Review do
  #   pipe_through :api
  # end
end
