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

  def whereis_name(key) do
    GenServer.call(__MODULE__, {:whereis_name, key})
  end

  def unregister_name(key) do
    GenServer.call(__MODULE__, {:unregister_name, key})
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
    {:ok, HashDict.new}
  end

  def handle_call({:register_name, key, pid}, _from, state) do\
    case HashDict.get(state, key) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, HashDict.put(state, key, pid)}

      _existing ->
        {:reply, :no, state}
    end
  end

  def handle_call({:whereis_name, key}, _from, state) do
    {:reply, HashDict.get(state, key, :undefined), state}
  end

  def handle_call({:unregister_name, key}, _from, state) do
    {:reply, key, HashDict.delete(state, key)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, deregister_pid(state, pid)}
  end
  def handle_info(_, state), do: {:noreply, state}

  defp deregister_pid(state, pid) do
    state
    |> Enum.reject(fn({_key, value}) ->
      value == pid
    end)
    |> Enum.into(HashDict.new)
  end
end
