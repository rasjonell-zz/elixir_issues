defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_into_descending_order: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "test"]) == :help
    assert parse_args(["--help", "test"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort descending orders the correct way" do
    fake_data = [%{"created_at" => "c"}, %{"created_at" => "a"}, %{"created_at" => "b"}]
    result = sort_into_descending_order(fake_data)

    issues = Enum.map(result, & &1["created_at"])
    assert issues == ~w{c b a}
  end
end
