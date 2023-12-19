defmodule EctoQueryPlus.MixProject do
  use Mix.Project

  @github_url "https://github.com/vasuadari/ecto_query_plus"
  @version "0.1.1"

  def project do
    [
      app: :ecto_query_plus,
      description: "Lets you compose ecto queries in a functional way.",
      docs: docs(),
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
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
      {:ecto, ">= 3.0.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/vasuadari/ecto_query_plus",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"Github" => @github_url}
    ]
  end
end
