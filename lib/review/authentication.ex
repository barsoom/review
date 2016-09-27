defmodule Review.Authentication do
  defmacro __using__(_opts) do
    quote do
      def authenticate(conn, options) do
        config = options |> Enum.into(%{})

        if valid_credentials?(conn.params[config.param], config.secret) do
          conn
        else
          conn |> deny_and_halt
        end
      end

      defp valid_credentials?(_anything, nil), do: true
      defp valid_credentials?(provided_auth_key, auth_key_in_config) do
        provided_auth_key == auth_key_in_config
      end

      defp deny_and_halt(conn) do
        conn |> send_resp(403, "Denied (probably an invalid key?)") |> halt
      end
    end
  end
end
