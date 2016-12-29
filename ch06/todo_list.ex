defmodule TodoList do
  defstruct auto_id: 0, entries: HashDict.new

  defmodule TodoItem do
    defstruct title: nil, id: nil, date: nil
  end

  def new do
    %TodoList{}
  end

  def add_entry(%TodoList{auto_id: auto_id, entries: entries} = todo_list, %{date: date, title: title}) do
    new_auto_id = auto_id + 1
    new_entries = HashDict.put(entries,
                               new_auto_id,
                               %TodoItem{id: new_auto_id,
                                         title: title,
                                         date: date})

    %TodoList{todo_list | auto_id: new_auto_id, entries: new_entries}
  end

  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_k, %TodoItem{date: item_date}}) ->
      date == item_date
    end)
    |> Enum.map(fn({_k, v}) -> v end)
  end
end

