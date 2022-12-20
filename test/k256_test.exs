defmodule K256Test do
  use ExUnit.Case
  doctest K256

  test "add" do
    assert K256.add(40, 2) == 42
  end
end
