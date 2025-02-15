defmodule SIO do
  @moduledoc """
  A module responsible for spawning logging tasks to be
  handled by the SIO node.
  """

  def inspect(message) do
    spawn_task(message, :inspect, trace_location())
  end

  def puts(message) do
    spawn_task(message, :puts, trace_location())
  end

  def receive_log(message, fun, loc) do
    IO.puts("\e[90m📍 #{loc.macro_loc}\e[0m")
    IO.puts("\e[90m   #{loc.micro_loc}\e[0m")

    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.to_time()
      |> Time.truncate(:second)

    IO.puts("\e[90m⌚ #{timestamp} UTC\e[0m")
    IO.puts("\t")

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

  defp trace_location do
    IO.inspect(Process.info(self(), :current_stacktrace))
    {:current_stacktrace, stacktrace} = Process.info(self(), :current_stacktrace)
    [_self, _insp_or_puts, _trace, caller | _rest] = stacktrace
    {mod, fun, arity, meta} = caller
    file = Keyword.get(meta, :file)
    line = Keyword.get(meta, :line)

    short_mod = mod |> to_string() |> String.replace_prefix("Elixir.", "")
    %{macro_loc: "#{short_mod}.#{fun}/#{arity}", micro_loc: "#{file}:#{line}"}
  end
end
