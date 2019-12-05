defmodule Main do
  def run(puzzle) do
    result = case puzzle do
      "1.1" ->
        Path.join("inputs", "1.txt")
        |> read("\n")
        |> Day1.solve_1

      "1.2" ->
        Path.join("inputs", "1.txt")
        |> read("\n")
        |> Day1.solve_2

      "2.1" ->
        Path.join("inputs", "2.txt")
        |> read(",")
        |> Day2.solve_1

      "2.2" ->
      Path.join("inputs", "2.txt")
        |> read(",")
        |> Day2.solve_2

      "3.1" ->
      Path.join("inputs", "3.txt")
        |> read("\n")
        |> Day3.solve_1

      "3.2" ->
      Path.join("inputs", "3.txt")
        |> read("\n")
        |> Day3.solve_2

      _ -> IO.puts "What puzzle???"
    end
    IO.puts result
  end

  def read(path, separator) do
    case File.read(path) do
      {:ok, body} -> String.split(body, separator)
      {:error, reason} -> IO.puts("Oh No: #{reason}")
    end
  end
end

[arg1 | _rest] = System.argv
Main.run(arg1)