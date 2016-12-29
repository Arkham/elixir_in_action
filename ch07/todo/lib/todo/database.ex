defmodule Todo.Database do
  use GenServer

  @worker_count 3

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def init(db_folder) do
    worker_pool =
      1..@worker_count
      |> Enum.map(fn(index) ->
        {:ok, pid} = Todo.DatabaseWorker.start(db_folder)
        {index, pid}
      end)
      |> Enum.into(HashDict.new)

    {:ok, worker_pool}
  end

  def handle_cast({:store, key, data}, worker_pool) do
    pid = get_worker(worker_pool, key)
    Todo.DatabaseWorker.store(pid, key, data)
    {:noreply, worker_pool}
  end

  def handle_call({:get, key}, _from, worker_pool) do
    pid = get_worker(worker_pool, key)
    {:reply, Todo.DatabaseWorker.get(pid, key), worker_pool}
  end

  defp get_worker(worker_pool, key) do
    HashDict.fetch!(worker_pool, :erlang.phash(key, @worker_count))
  end
end
