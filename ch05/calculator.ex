defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def add(pid, n), do: send(pid, {:add, n})
  def sub(pid, n), do: send(pid, {:sub, n})
  def mul(pid, n), do: send(pid, {:mul, n})
  def div(pid, n), do: send(pid, {:div, n})

  def value(pid) do
    send(pid, {:value, self})

    receive do
      {:response, value} -> value
    end
  end

  defp loop(current_value) do
    new_value = receive do
      message -> process_message(current_value, message)
    end

    loop(new_value)
  end

  defp process_message(current, {:add, n}), do: current + n
  defp process_message(current, {:sub, n}), do: current - n
  defp process_message(current, {:mul, n}), do: current * n
  defp process_message(current, {:div, n}), do: current / n
  defp process_message(current, {:value, caller}) do
    send(caller, {:response, current})
    current
  end
  defp process_message(current, unknown) do
    IO.puts "invalid request #{inspect(unknown)}"
    current
  end
end
