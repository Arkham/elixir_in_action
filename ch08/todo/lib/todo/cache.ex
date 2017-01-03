defmodule Todo.Cache do
  use GenServer

  def start_link do
    IO.puts "Starting Todo.Cache"
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        GenServer.call(__MODULE__, {:server_process, todo_list_name})

      pid -> pid
    end
  end

  def init(nil) do
    {:ok, nil}
  end

  def handle_call({:server_process, todo_list_name}, _from, state) do
    server_pid = case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        {:ok, pid} = Todo.ServerSupervisor.start_child(todo_list_name)
        pid

      pid -> pid
    end

    {:reply, server_pid, state}
  end
end
