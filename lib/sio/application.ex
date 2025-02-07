defmodule SIO.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    clear_screen()
    print_welcome()

    children = [
      {Task.Supervisor, name: SIO.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: SIO.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp clear_screen do
    IO.write("\e[H\e[2J")
  end

  defp print_welcome do
    IO.puts("""
    #{IO.ANSI.yellow()}- Welcome to SideIO! -#{IO.ANSI.reset()}
    #{IO.ANSI.yellow()}Add some #{IO.ANSI.red()}SIO.inspect#{IO.ANSI.yellow()} or #{IO.ANSI.red()}SIO.puts#{IO.ANSI.yellow()} calls in your code to log them here! 🫰#{IO.ANSI.reset()}
    """)
  end
end
