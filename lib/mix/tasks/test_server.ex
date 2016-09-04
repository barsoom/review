defmodule Mix.Tasks.TestServer do
  use Mix.Task

  def run([]) do
    spawn fn ->
      Mix.Tasks.Phoenix.Server.run([])
    end

    run_test_commands
  end

  defp run_test_commands do
    IO.read(:stdio, :line)
    |> String.split
    |> run_test

    run_test_commands
  end

  defp run_test([ "mix", "test", path ]) do
    IO.puts "Running tests..."
    { output, _exit_status } = System.cmd("mix", [ "test", path, "--color" ])
    IO.puts output
  end

  defp run_test([ "mix", "test" ]) do
    IO.puts "Running tests..."
    { output, _exit_status } = System.cmd("mix", [ "test", "--color" ])
    IO.puts output
  end

  defp run_test(_) do
    # ignore unknown commands
  end
end
