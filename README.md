# MarkdownDoctest

Test Elixir code blocks directly from Markdown files, without `iex>` syntax.

```elixir
# In test suite file
use MarkdownDoctest, file: "README.md"

# Filter out the traditional `def deps` block
use MarkdownDoctest, file: "README.md", except: &(&1 =~ "def deps do")
```

Errors will be shown with a stacktrace pointing to the line that failed inside the markdown file.

## Installation

The package can be installed by adding `markdown_doctest` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:markdown_doctest, "~> 0.1.0", only: :test, runtime: false}
  ]
end
```
