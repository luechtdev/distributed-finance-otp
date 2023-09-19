defmodule BankServiceTest do
  use ExUnit.Case
  doctest BankService

  test "greets the world" do
    assert BankService.hello() == :world
  end
end
