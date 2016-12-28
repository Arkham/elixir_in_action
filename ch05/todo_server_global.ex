defmodule TodoServerGlobal do
  @name :todo_server

  def start do
    pid = spawn(fn ->
      loop(TodoList.new)
    end)
    Process.register(pid, @name)
  end

  def add_entry(entry), do: send(@name, {:add_entry, entry})
  def entries(date) do
    send(@name, {:entries, date, self})
    receive do
      {:response, entries} -> entries
    after 5000 ->
      {:error, :timeout}
    end
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      message -> process_message(todo_list, message)
    end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp process_message(todo_list, {:entries, date, caller}) do
    send(caller, {:response, TodoList.entries(todo_list, date)})
    todo_list
  end
end

