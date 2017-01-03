defmodule Todo.Cache do
  use GenServer

  def start_link do
    IO.puts "Starting Todo.Cache"
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    GenServer.call(__MODULE__, {:server_process, todo_list_name})
  end

  def init(nil) do
    Todo.Database.start_link("./persist/")
    {:ok, HashDict.new}
  end

  def handle_call({:server_process, todo_list_name}, _from, todo_servers) do
    case HashDict.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_server} = Todo.Server.start_link(todo_list_name)
        new_todo_servers = HashDict.put(todo_servers, todo_list_name, new_server)
        {:reply, new_server, new_todo_servers}
    end
  end
end
