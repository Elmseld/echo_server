defmodule EchoServer do

  def start() do
    if !(Process.registered() |> Enum.member?(__MODULE__)) do
      start_server()
    else
      IO.puts("You need to murder me first.")
    end
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

    def start_server() do
      spawn(__MODULE__, :mailbox, [])
      |> Process.register(__MODULE__)
    end

    def mailbox() do
      receive do
        :hello -> IO.puts("Hi you!")
        mailbox()
        :happy -> Quotes.random() |> Map.get("text") |> IO.puts
        mailbox()
        :stop  -> IO.puts("YOU KILLED MEEEE")
      end
    end
end
