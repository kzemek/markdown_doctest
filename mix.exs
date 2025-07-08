defmodule MarkdownDoctest.MixProject do
  use Mix.Project

  def project do
    [
      app: :markdown_doctest,
      version: "0.1.0",
      description: "Test Elixir code blocks directly from Markdown files, without `iex>` syntax",
      package: package(),
      source_url: "https://github.com/kzemek/markdown_doctest",
      homepage_url: "https://github.com/kzemek/markdown_doctest",
      docs: docs(),
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.38.1", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "MarkdownDoctest",
      extras: ["LICENSE", "NOTICE"]
    ]
  end

  defp package do
    [
      links: %{"GitHub" => "https://github.com/kzemek/markdown_doctest"},
      licenses: ["Apache-2.0"]
    ]
  end
end
