defmodule MultiDict do
  def new do
    HashDict.new
  end

  def add_entry(dict, key, value) do
    HashDict.update(dict,
                    key,
                    [value],
                    &[value|&1])
  end

  def entries(dict, key) do
    HashDict.get(dict, key, [])
  end
end
