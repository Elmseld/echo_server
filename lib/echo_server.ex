defmodule EchoServer do

  def start() do
    if !(Process.registered() |> Enum.member?(__MODULE__)) do
      start_server()
      |> Process.register(__MODULE__)
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
    try do
      send(__MODULE__, term)
    rescue
      ArgumentError ->
        IO.puts("I'm dead, try give me some elixir of life!")
    end
  end

    def start_server() do
      spawn(fn -> send(__MODULE__,
        receive do
          :hello -> IO.puts("Hi you!")
          :happy -> Quotes.random() |> Map.get("text") |> IO.puts
          :stop  -> Process.exit(self(), :kill)
            end)
      end)
    end
end
