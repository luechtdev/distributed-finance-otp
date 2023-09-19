defmodule StockRegistryTest do
  use ExUnit.Case
  doctest StockRegistry

  test "greets the world" do
    assert StockRegistry.hello() == :world
  end
end
