defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      deps: deps(),
      app: :issues,
      name: "Issues",
      version: "0.1.0",
      elixir: "~> 1.8",
      escript: escript_config(),
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/rasjonell/issues"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:earmark, "~> 1.4"},
      {:httpoison, "~> 1.6"},
      {:ex_doc, "~> 0.21.2"}
    ]
  end

  defp escript_config do
    [
      main_module: Issues.CLI
    ]
  end
end
