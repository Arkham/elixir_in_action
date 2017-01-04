defmodule Todo.ServerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_child(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def init(nil) do
    supervise([worker(Todo.Server, [])],
              strategy: :simple_one_for_one)
  end
end
