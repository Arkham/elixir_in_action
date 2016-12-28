defmodule TodoList do
  def new do
    MultiDict.new
  end

  def add_entry(todo_list, entry) do
    MultiDict.add_entry(todo_list, entry.date, entry)
  end

  def entries(todo_list, date) do
    MultiDict.entries(todo_list, date)
  end
end
