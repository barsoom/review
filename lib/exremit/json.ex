# Wrapper so that we don't rely on any particular library in multiple places in the code
defmodule Exremit.JSON do
  def encode(text) do
    Poison.encode!(text)
  end
end
