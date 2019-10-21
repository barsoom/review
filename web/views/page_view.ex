defmodule Review.PageView do
  use Review.Web, :view

  def render_elm(app_name, options \\ []) do
    options_json = options |> Enum.into(%{}) |> Poison.encode! |> String.replace("'", "\\u0027")

    """
    <div class="js-elm-app" data-app-name="#{app_name}" data-options='#{options_json}'></div>
    """
    |> raw
  end
end
