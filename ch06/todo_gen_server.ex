defmodule TodoServer do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def init(nil) do
    {:ok, TodoList.new}
  end

  def handle_cast({:add_entry, entry}, state) do
    IO.inspect state
    {:noreply, TodoList.add_entry(state, entry)}
  end

  def handle_call({:entries, date}, _from, state) do
    {:reply, TodoList.entries(state, date), state}
  end
end
