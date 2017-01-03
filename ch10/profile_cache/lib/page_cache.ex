defmodule PageCache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    {:ok, HashDict.new}
  end

  def cached(key, fun) do
    GenServer.call(__MODULE__, {:cached, key, fun})
  end

  def handle_call({:cached, key, fun}, _from, cache) do
    case HashDict.get(cache, key) do
      nil ->
        value = fun.()
        {:reply, value, HashDict.put(cache, key, value)}

      response ->
        {:reply, response, cache}
    end
  end
end
