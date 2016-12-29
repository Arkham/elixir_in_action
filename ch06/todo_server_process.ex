defmodule TodoServer do
  def start do
    ServerProcess.start(__MODULE__)
  end

  def add_entry(pid, entry) do
    ServerProcess.cast(pid, {:add_entry, entry})
  end

  def entries(pid, date) do
    ServerProcess.call(pid, {:entries, date})
  end

  def init do
    TodoList.new
  end

  def handle_cast({:add_entry, entry}, state) do
    TodoList.add_entry(state, entry)
  end

  def handle_call({:entries, date}, _from, state) do
    {TodoList.entries(state, date), state}
  end
end
