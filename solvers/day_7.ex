defmodule Day7 do
  def solve_1(raw_program) do
    program = Enum.map(raw_program, &Integer.parse/1)
            |> Enum.map(fn({token, _}) -> token end)
    { output, phases } = find_max!(program)
    IO.puts "output: #{output}"
    IO.puts "phases: #{phases |> Enum.join(",")}"
  end

  def solve_2(raw_program) do
    program = Enum.map(raw_program, &Integer.parse/1)
            |> Enum.map(fn({token, _}) -> token end)
    { output, phases } = find_max_with_feedback!(program)
    IO.puts "output: #{output}"
    IO.puts "phases: #{phases |> Enum.join(",")}"
  end

  def find_max_with_feedback!(program) do
    phase_combinations(5..9)
    |> Enum.map(fn phases ->
      amplifiers = make_amplifiers(program, self())
      { start_all_with_feedback!(amplifiers, phases), phases }
    end)
    |> Enum.max_by(fn({ output, phases }) -> output end)
  end

   def start_all_with_feedback!(amplifiers, phases) do
    Enum.zip(phases, amplifiers)
      |> Enum.each fn({ phase, amplifier_id }) ->
        send(amplifier_id, { :input, phase, self() })
    end
    start_with_feedback!(amplifiers)
  end

  def start_with_feedback!([first_id | rest], input \\ 0) do
    send(first_id, { :input, input, self() })
    case pass_outputs(rest) do
      { :continue, output } -> start_with_feedback!([first_id | rest], output)
      { :done, output } -> output
    end
  end

  def find_max!(program) do
    phase_combinations
    |> Enum.map(fn phases ->
      amplifiers = make_amplifiers(program, self())
      { start_all!(amplifiers, phases), phases }
    end)
    |> Enum.max_by(fn({ output, phases }) -> output end)
  end

  def start_all!(amplifiers, phases) do
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

  def pass_outputs(amplifiers, halted \\ 0)
  def pass_outputs([amplifier_id | rest], halted_count) do
    receive do
      { :done, id, output } ->
      send(amplifier_id, { :input, output, self() })
      pass_outputs(rest, halted_count)
    end
  end
  def pass_outputs([], halted_count) do
    receive do
      { :done, id, output } ->
        if halted_count == 4 do
          { :done, output }
        else
          { :continue, output }
        end
      { :halt, id } ->
        pass_outputs([], halted_count + 1)
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

  def phase_combinations(phases \\ (0..4), n \\ 5) do
    Utils.permutations(Enum.to_list(phases), n)
  end
end