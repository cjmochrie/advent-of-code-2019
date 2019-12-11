defmodule Day5 do
  def solve_1(raw_program) do
    input = IO.gets "What is the input?"
    program = Enum.map(raw_program, &Integer.parse/1)
              |> Enum.map(fn({token, _}) -> token end)
    parent = self()
    { :ok, computer } = Task.start fn -> Intcode.execute(
                                           %Intcode.Computer{
                                             program: program,
                                             position: 0,
                                             caller_id: parent
                                           }) end
    send(computer, { :input, input, parent })
    receive do
      { :done, output } ->
        IO.puts "Output: #{output}"
    after
      1_000 -> IO.puts "Never finished"
    end
  end
end