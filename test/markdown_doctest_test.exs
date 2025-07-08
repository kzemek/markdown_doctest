defmodule MarkdownDoctestTest do
  use ExUnit.Case
  doctest MarkdownDoctest

  test "greets the world" do
    assert MarkdownDoctest.hello() == :world
  end
end
