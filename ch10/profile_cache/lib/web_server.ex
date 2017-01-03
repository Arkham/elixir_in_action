defmodule WebServer do
  def index do
    :timer.sleep(100)
    "<html>Hello</html>"
  end
end
