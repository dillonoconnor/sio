defmodule SIO do
  @moduledoc false

  def inspect(message, loc \\ nil) do
    spawn_task(message, :inspect, loc)
  end

  def puts(message, loc \\ nil) do
    spawn_task(message, :puts, loc)
  end

  def receive_log(message, fun, loc) do
    if loc, do: IO.puts("\e[90m#{loc}\e[0m")

    timestamp =
      DateTime.utc_now()
      |> Calendar.strftime("%Y-%m-%d %H:%M:%S.%3fZ")

    IO.puts("\e[90m#{String.duplicate("-", 6)}#{timestamp}#{String.duplicate("-", 6)}\e[0m")

    case fun do
      :inspect ->
        IO.inspect(
          message,
          pretty: true,
          syntax_colors: [
            number: :yellow,
            atom: :cyan,
            string: :green,
            boolean: :light_red,
            nil: :red
          ]
        )

      :puts ->
        IO.puts(message)

      _ ->
        IO.puts(message)
    end

    IO.puts("\e[90m" <> String.duplicate("-", 39) <> "\e[0m")
    IO.puts("\n")
  end

  def spawn_task(message, fun, loc) do
    remote_supervisor()
    |> Task.Supervisor.async(__MODULE__, :receive_log, [message, fun, loc])
    |> Task.await()
  end

  defp remote_supervisor do
    {SIO.TaskSupervisor, :sio@localhost}
  end

  defmacro log_location do
    quote do
      "#{__ENV__.file}:#{__ENV__.line}"
    end
  end
end
