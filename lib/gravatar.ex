defmodule Gravatar do
  def hash(email) do
    :crypto.hash(:md5, email)
    |> Base.encode16(case: :lower)
  end
end
