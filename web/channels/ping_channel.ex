defmodule Review.PingChannel do
  use Phoenix.Channel

  import Ecto.Query

  def join(_channel, _auth, socket) do
    send self, :after_join

    {:ok, _} = :timer.send_interval(1 * 1000, :send_ping)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "welcome", %{ revision: System.get_env("HEROKU_SLUG_COMMIT") }

    {:noreply, socket}
  end

  def handle_info(:send_ping, socket) do
    push socket, "ping", %{}
    {:noreply, socket}
  end
end
