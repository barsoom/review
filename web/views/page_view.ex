defmodule Exremit.PageView do
  use Exremit.Web, :view

  def render_elm(app_name, options \\ []) do
    options_json = options |> Enum.into(%{}) |> Poison.encode!

    """
    <div class="js-elm-app" data-app-name="#{app_name}" data-options='#{options_json}'></div>
    """
    |> raw
  end
end
