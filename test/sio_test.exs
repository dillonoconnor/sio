defmodule SIOTest do
  use ExUnit.Case
  doctest SIO

  test "greets the world" do
    assert SIO.hello() == :world
  end
end
