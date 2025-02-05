defmodule SIO do
  @moduledoc false

  def inspect(message, loc \\ nil) do
    spawn_task(message, :inspect, loc)
  end

  def puts(message, loc \\ nil) do
    spawn_task(message, :puts, loc)
  end

  def receive_log(message, fun, loc) do
    IO.puts("\n")
    IO.puts("\e[34m#{String.duplicate("-", 17)} Log #{String.duplicate("-", 18)}\e[0m")
    if loc, do: IO.puts("\e[95m#{loc}\e[0m")
    IO.puts("\e[37m#{DateTime.utc_now()}\e[0m")
    IO.puts("\n")

    case fun do
      :inspect ->
        IO.inspect(
          message,
          pretty: true,
          syntax_colors: [
            number: :magenta,
            atom: :cyan,
            string: :green,
            boolean: :yellow,
            nil: :red
          ]
        )

      :puts ->
        IO.puts(message)

      _ ->
        IO.puts(message)
    end

    IO.puts("\e[34m" <> String.duplicate("-", 40) <> "\e[0m")
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
