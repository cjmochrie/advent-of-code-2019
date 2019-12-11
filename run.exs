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

      "4.1" ->
      Path.join("inputs", "4.txt")
        |> read("-")
        |> Day4.solve_1

     "4.2" ->
      Path.join("inputs", "4.txt")
        |> read("-")
        |> Day4.solve_2

      "5.1" ->
      Path.join("inputs", "5.txt")
        |> read(",")
        |> Day5.solve_1

      "6.1" -> Path.join("inputs", "6.txt")
        |> read("\n")
        |> Day6.solve_1

      "6.2" -> Path.join("inputs", "6.txt")
        |> read("\n")
        |> Day6.solve_2

      "7.1" -> Path.join("inputs", "7.txt")
        |> read(",")
        |> Day7.solve_1

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