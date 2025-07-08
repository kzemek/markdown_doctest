defmodule MarkdownDoctest do
  @external_resource "README.md"
  @moduledoc File.read!("README.md") |> String.replace_prefix("# MarkdownDoctest\n\n", "")

  defmacro __using__(opts) do
    path = Keyword.fetch!(opts, :file)

    {except, _} =
      opts
      |> Keyword.get(:except, quote(do: fn _ -> false end))
      |> Code.eval_quoted([], __CALLER__)

    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.with_index(1)
    |> Enum.chunk_while(
      nil,
      fn
        {"```elixir", _line}, nil ->
          {:cont, {:in_block, "```", []}}

        {"````elixir", _line}, nil ->
          {:cont, {:in_block, "````", []}}

        {end_marker, line}, {:in_block, end_marker, acc} ->
          start_line = line - length(acc)
          block = acc |> Enum.reverse() |> Enum.join("\n")
          {:cont, {block, start_line}, nil}

        {content, _line}, {:in_block, end_marker, acc} ->
          {:cont, {:in_block, end_marker, [content | acc]}}

        {_content, _line}, acc ->
          {:cont, acc}
      end,
      fn _ -> {:cont, nil} end
    )
    |> Enum.reject(fn {block, _line} -> except.(block) end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{block, line}, index} ->
      quoted = Code.string_to_quoted!(block, file: path, line: line)

      file = "(for markdown doctest at) #{path}"
      name = "#{path} example #{index}"
      quoted = Macro.escape(quoted)

      quote file: file, bind_quoted: [name: name, quoted: quoted] do
        doc = ExUnit.Case.register_test(__MODULE__, __ENV__.file, __ENV__.line, :mdtest, name, [])
        def unquote(doc)(_), do: unquote(quoted)
      end
    end)
  end
end
