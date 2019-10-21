defmodule Review.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Review.Web, :controller
      use Review.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def webhook do
    quote do
      use Phoenix.Controller
      use Review.Authentication

      plug(:authenticate, param: "secret", secret: Application.get_env(:review, :webhook_secret))
    end
  end

  def api do
    quote do
      use Phoenix.Controller
      use Review.Authentication

      plug(:authenticate, param: "secret", secret: Application.get_env(:review, :api_secret))
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: ReviewWeb

      alias Review.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]

      import ReviewWeb.Router.Helpers
      use Review.Authentication

      plug(:authenticate, param: "auth_key", secret: Application.get_env(:review, :auth_key))
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/review_web/templates", namespace: ReviewWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import ReviewWeb.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Review.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end