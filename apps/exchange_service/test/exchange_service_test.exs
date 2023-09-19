defmodule ExchangeServiceTest do
  use ExUnit.Case
  doctest ExchangeService

  test "greets the world" do
    assert ExchangeService.hello() == :world
  end
end
