defmodule Day7 do
  def solve_1(raw_program) do
    program = Enum.map(raw_program, &Integer.parse/1)
            |> Enum.map(fn({token, _}) -> token end)
    { output, phases } = find_max!(program)
    IO.puts "output: #{output}"
    IO.puts "phases: #{phases |> Enum.join(",")}"
  end

  def find_max!(program) do
    phase_combinations
    |> Enum.map(fn phases ->
      { start_all!(program, phases), phases }
    end)
    |> Enum.max_by(fn({ output, phases }) -> output end)
  end

  def start_all!(program, phases) do
    amplifiers = make_amplifiers(program, self())
    Enum.zip(phases, amplifiers)
      |> Enum.each fn({ phase, amplifier_id }) ->
        send(amplifier_id, { :input, phase, self() })
    end
    result = start!(amplifiers)
  end

  def start!([amplifier_id | rest], input \\ 0) do
    send(amplifier_id, { :input, input, self() })
    pass_outputs(rest)
  end

  def pass_outputs([amplifier_id | rest]) do
    receive do
      { :done, id, output } ->
      send(amplifier_id, { :input, output, self() })
      pass_outputs(rest)
    end
  end
  def pass_outputs([]) do
    receive do
      { :done, id, output } ->
      output
    end
  end


  def make_amplifiers(program, parent_id, n \\ 5) do
    Enum.map(
      (1..n),
      fn(n) ->
        Task.start fn ->
          default_computer(program, parent_id)
          |> execute
        end
      end
    )
    |> Enum.map(fn({ :ok, id }) -> id end)
  end

  def execute(computer) do
    Intcode.execute(computer)
  end

  def default_computer(program, parent_id) do
    %Intcode.Computer{
      program: program,
      caller_id: parent_id
    }
  end

  def phase_combinations(n \\ 5) do
    Utils.permutations(Enum.to_list(0..(n - 1)), n)
  end
end