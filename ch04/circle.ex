defmodule Circle do
  @moduledoc "Implements basic circle functions"

  @pi 3.14159

  @spec area(number) :: number
  @doc "Computes the area of a circle"
  def area(r), do: r*r*@pi

  @spec circumference(number) :: number
  @doc "Computes the circumference of a circle"
  def circumference(r), do: 2*r*@pi
end
