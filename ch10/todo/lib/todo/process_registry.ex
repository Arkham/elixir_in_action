defmodule Todo.ProcessRegistry do
  use GenServer

  import Kernel, except: [send: 2]

  def start_link do
    IO.puts "Starting Todo.ProcessRegistry"
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register_name(key, pid) do
    GenServer.call(__MODULE__, {:register_name, key, pid})
  end

  def unregister_name(key) do
    GenServer.call(__MODULE__, {:unregister_name, key})
  end

  def whereis_name(key) do
    case :ets.lookup(:process_registry, key) do
      [{^key, value}] -> value
      _ -> :undefined
    end
  end

  def send(key, message) do
    case whereis_name(key) do
      :undefined -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  def init(nil) do
    :ets.new(:process_registry, [:named_table, :public, :set])
    {:ok, nil}
  end

  def handle_call({:register_name, key, pid}, _from, state) do\
    case whereis_name(key) do
      :undefined ->
        Process.monitor(pid)
        :ets.insert(:process_registry, {key, pid})
        {:reply, :yes, state}

      _name ->
        {:reply, :no, state}
    end
  end

  def handle_call({:unregister_name, key}, _from, state) do
    :ets.delete(:process_registry, key)
    {:reply, key, state}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    :ets.match_delete(:process_registry, {:_, pid})
    {:noreply, state}
  end
  def handle_info(_, state), do: {:noreply, state}
end
