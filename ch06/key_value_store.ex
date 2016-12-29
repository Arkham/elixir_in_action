defmodule KeyValueStore do
  def start do
    ServerProcess.start(__MODULE__)
  end

  def put(pid, key, value) do
    ServerProcess.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    ServerProcess.call(pid, {:get, key})
  end

  def init do
    HashDict.new
  end

  def handle_cast({:put, key, value}, state) do
    HashDict.put(state, key, value)
  end

  def handle_call({:get, key}, _from, state) do
    {HashDict.get(state, key), state}
  end
end
