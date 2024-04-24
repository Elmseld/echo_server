defmodule EchoServerMulti do

  @moduledoc """
    Create a multiserver

  """
  def start(n, m) do
    # if !(Process.registered() |> Enum.member?(__MODULE__)) do
      1..n
      |> Enum.map(&start_server/1)
      # |> Process.register(__MODULE__)
    # else
    #   IO.puts("Stop it, one is enough! Try monagamy or murder, the choice is yours...")
    # end
  end

  def stop() do
    send_to_server(:stop)
  end

  def print(:stop), do: :noop
  def print(term) do
    send_to_server(term)
  end

  defp send_to_server(term) do
    try do
      send(__MODULE__, term)
    rescue
      ArgumentError ->
        IO.puts("I'm dead, try give me some elixir of life!")
    end
  end

    def start_server(number) do
      server_name = "happy_worker_#{number}" |> String.to_atom
      msg = "hello_#{number}" |> String.to_atom
      spawn(fn -> send(server_name,
        receive do
          ^msg -> IO.puts("Hi #{number}!")
            end)
      end)
    end
end
