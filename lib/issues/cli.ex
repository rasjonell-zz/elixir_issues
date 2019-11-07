defmodule Issues.CLI do
  @default_count 4

  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @moduledoc """
  Handle command line parsing and the dispatch to the various functions that end up generating a table of the last _n_ issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
    |> IO.inspect()
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it it a github username, project name, and (optionally) the number of entries to format.

  Return a tuple of `{ user, project, count }` or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <repository> [ count | #{@default_count} ]
    """)

    System.halt()
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    IO.puts("Error fetching from GitHub: #{error["message"]}")
    System.halt(2)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(&(&1["created_at"] >= &2["created_at"]))
  end

  defp args_to_internal_representation([user, project, count]),
    do: {user, project, String.to_integer(count)}

  defp args_to_internal_representation([user, project]), do: {user, project, @default_count}
  defp args_to_internal_representation(_), do: :help
end
