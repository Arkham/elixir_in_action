defmodule Todo.Server do
  use GenServer

  def start_link(name) do
    IO.puts "Starting Todo.Server for #{name}"
    GenServer.start_link(__MODULE__, name)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new}}
  end

  def handle_cast({:add_entry, entry}, {name, todo_list}) do
    new_todo_list = Todo.List.add_entry(todo_list, entry)
    Todo.Database.store(name, new_todo_list)
    {:noreply, {name, new_todo_list}}
  end

  def handle_call({:entries, date}, _from, {_name, todo_list} = state) do
    {:reply, Todo.List.entries(todo_list, date), state}
  end
end
