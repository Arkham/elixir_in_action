defmodule Todo.List do
  alias Todo.{List, Item}

  defstruct auto_id: 0, entries: HashDict.new

  def new do
    %List{}
  end

  def add_entry(%List{auto_id: auto_id, entries: entries} = todo_list, %{date: date, title: title}) do
    new_auto_id = auto_id + 1
    new_entries = HashDict.put(entries,
                               new_auto_id,
                               %Item{id: new_auto_id,
                                         title: title,
                                         date: date})

    %List{todo_list | auto_id: new_auto_id, entries: new_entries}
  end

  def entries(%List{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_k, %Item{date: item_date}}) ->
      date == item_date
    end)
    |> Enum.map(fn({_k, v}) -> v end)
  end
end
