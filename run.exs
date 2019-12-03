defmodule Main do
  def run(puzzle) do
    result = case puzzle do
      "1.1" ->
        Path.join("inputs", "1.txt")
        |> read
        |> Solvers.solve_1_1
      "1.2" ->
        Path.join("inputs", "1.txt")
        |> read
        |> Solvers.solve_1_2
      _ -> IO.puts "What puzzle???"
    end
    IO.puts result
  end

  def read(path) do
    case File.read(path) do
      {:ok, body} -> String.split(body, "\n")
      {:error, reason} -> IO.puts("Oh No: #{reason}")
    end
  end
end

[arg1 | _rest] = System.argv
Main.run(arg1)