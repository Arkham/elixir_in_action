defmodule Todo.Database do
  @pool_size 3

  def start_link(db_folder) do
    IO.puts "Starting Todo.Database"
    Todo.PoolSupervisor.start_link(db_folder, @pool_size)
  end

  def store(key, data) do
    {_results, bad_nodes} =
      :rpc.multicall(__MODULE__, :store_local, [key, data],
                     :timer.seconds(5))

    Enum.each(bad_nodes, &IO.puts("Store failed on node #{&1}"))

    :ok
  end

  def store_local(key, data) do
    key
    |> get_worker_id
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> get_worker_id
    |> Todo.DatabaseWorker.get(key)
  end

  defp get_worker_id(key) do
    :erlang.phash(key, @pool_size) + 1
  end
end
