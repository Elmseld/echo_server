defmodule EchoServer do
  @moduledoc """
  Super simple server that only handle a couple of atom_calls.

  Going for the deep basics and pushing back the urge to use Genserver.

  Made to not be able to break, try me please.
  """

  def start() do
    pid = start_a_server()
    register_the_server(pid)
  end

  def stop() do
    send_to_server(:stop)
  end

  def print(:stop), do: :noop
  def print(term) do
    send_to_server(term)
  end

  defp send_to_server(term) do
    # Just wanted to try try, this should be an if as in the start-func
    try do
      send(__MODULE__, term)
    rescue
      ArgumentError ->
        IO.puts("I'm dead, try give me some elixir of life!")
    end
  end

    def start_a_server() do
      spawn(__MODULE__, :mailbox, [])
    end

    defp register_the_server(pid) do
      if __MODULE__ not in Process.registered() do
        Process.register(pid, __MODULE__)
      else
        IO.puts("You need to murder me first.")
      end
    end

    def mailbox() do
      receive do
        :hello ->
          IO.puts("Hi you!")
          mailbox()
        :happy ->
          Quotes.random() |> Map.get("text") |> IO.puts()
          mailbox()
        :stop  ->
          IO.puts("YOU KILLED MEEEE")
      end
    end
end
