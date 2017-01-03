defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(nil) do
    processes = [worker(Todo.Cache, [])]
    supervise(processes, strategy: :one_for_one)
  end
end
