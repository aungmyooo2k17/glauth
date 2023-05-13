defmodule GlauthWeb.ErrorEncoder do
  def encode(term, _opts) when is_tuple(term) do
    [elem(term, 0), Map.new(elem(term, 1))]
  end

  def encode(term, _opts) do
    Poison.encode(term)
  end
end
