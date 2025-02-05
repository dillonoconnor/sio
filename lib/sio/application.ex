defmodule SIO.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: SIO.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: SIO.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
