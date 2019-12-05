defmodule Day3 do
  def solve_1([wire_a, wire_b]) do
    { a_horizontal, a_vertical } = segments([], [], { 0, 0, 0 }, parse_input(wire_a))
    { b_horizontal, b_vertical } = segments([], [], { 0, 0, 0 }, parse_input(wire_b))
    sorted_a_horizontal = Enum.sort_by(a_horizontal, fn({ x, _, _, _}) -> abs(x) end, &<=/2)
    sorted_a_vertical = Enum.sort_by(a_vertical, fn({ y, _, _, _}) -> abs(y) end, &<=/2)
    sorted_b_horizontal = Enum.sort_by(b_horizontal, fn({ x, _, _, _}) -> abs(x) end, &<=/2)
    sorted_b_vertical = Enum.sort_by(b_vertical, fn({ y, _, _, _}) -> abs(y) end, &<=/2)
    closest_h_v = closest_intersection(sorted_a_horizontal, sorted_b_vertical, sorted_b_vertical, 9999999999, &distance_to_origin/2)
    closest_intersection(sorted_a_vertical, sorted_b_horizontal, sorted_b_horizontal, closest_h_v, &distance_to_origin/2)
  end

  def solve_2([wire_a, wire_b]) do
    # Sort by number of steps to reach end of segment
    { a_horizontal, a_vertical } = segments([], [], { 0, 0, 0 }, parse_input(wire_a))
    { b_horizontal, b_vertical } = segments([], [], { 0, 0, 0 }, parse_input(wire_b))
    sorted_a_horizontal = Enum.sort_by(a_horizontal, &steps_to_terminus/1, &<=/2)
    sorted_a_vertical = Enum.sort_by(a_vertical, &steps_to_terminus/1, &<=/2)
    sorted_b_horizontal = Enum.sort_by(b_horizontal, &steps_to_terminus/1, &<=/2)
    sorted_b_vertical = Enum.sort_by(b_vertical, &steps_to_terminus/1, &<=/2)
    closest_h_v = closest_intersection(sorted_a_horizontal, sorted_b_vertical, sorted_b_vertical, 9999999999, &steps_from_origin/2)
    closest_intersection(sorted_a_vertical, sorted_b_horizontal, sorted_b_horizontal, closest_h_v, &steps_from_origin/2)
  end

  def steps_to_terminus({ _, _, distance, steps }) do
    distance + steps
  end

  def closest_intersection([a_first | a_rest], [b_first | b_rest], all_b, shortest, distance_function) do
    cond do
      # can write a better early return for the part 2 case by comparing a_first's steps to shortest
      beyond_shortest_distance(a_first, shortest) -> shortest
      beyond_shortest_distance(b_first, shortest) -> closest_intersection(a_rest, all_b, all_b, shortest, distance_function)
      true -> case segment_intersection(a_first, b_first) do
        :ok -> closest_intersection([a_first | a_rest], b_rest, all_b, Enum.min([distance_function.(a_first, b_first), shortest]), distance_function)
        :no -> closest_intersection([a_first | a_rest], b_rest, all_b, shortest, distance_function)
      end
    end
  end

  def closest_intersection([_ | a_rest], [], all_b, shortest, distance_function) do
    IO.puts "Ran out of segments in B. shortest #{shortest}"
    closest_intersection(a_rest, all_b, all_b, shortest, distance_function)
  end

  def closest_intersection([], _, _, shortest, _) do
    IO.puts "Ran out of segments in A. shortest #{shortest}"
    shortest
  end

  def beyond_shortest_distance({ x, _, _, _ }, shortest) do
    abs(x) > shortest
  end

  def segment_intersection({ x, y0, y1, _ }, { y, x0, x1, _ }) do
    if Enum.min([x0, x1]) <= x and
       x <= Enum.max([x0, x1]) and
       Enum.min([y0, y1]) < y and
       y < Enum.max([y0, y1]) do
      :ok
    else
      :no
    end
  end

  def distance_to_origin({ x, _, _, _ }, { y, _, _, _ }) do
    abs(x) + abs(y)
  end

  def steps_from_origin({ x, y0, _, x_steps }, { y, x0, _, y_steps }) do
    Enum.sum([
      x_steps,
      y_steps,
      abs(x - x0),
      abs(y - y0)
    ])
  end

  def segments(horizontal, vertical, { x, y, steps }, [ { direction, distance } | rest ]) do
    case direction do
      "U" -> segments(horizontal, [ { x, y, y + distance, steps, } | vertical ], { x, y + distance, steps + distance }, rest)
      "D" -> segments(horizontal, [ { x, y, y - distance, steps } | vertical ], { x, y - distance, steps + distance }, rest)
      "L" -> segments([ { y, x, x - distance, steps } | horizontal ], vertical, { x - distance, y, steps + distance }, rest)
      "R" -> segments([ { y, x, x + distance, steps} | horizontal ], vertical, { x + distance, y, steps + distance }, rest)
    end
  end

  def segments(horizontal, vertical, _, []) do
    { horizontal, vertical }
  end

  def parse_input(instruction_string) do
    String.split(instruction_string, ",")
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(instruction) do
    { instruction, distance_string } = String.split_at(instruction, 1)
    { distance_amount, _ } = Integer.parse(distance_string)
    { instruction,  distance_amount }
  end
end

# Build 4 lists
# Wire A vertical segments (x, y0, y1)
# Wire A horizontal segments (y, x0, x1)
# Wire B vertical segments
# Wire B horizontal segments


# sort each list by 1st coordinate (x for vertical segments, y for horizontal segments)

# iterate over wire A vertical segments and check against Wire B horizontal segments
# intersection if Bx0 <= Ax <= Bx1 && Ay0 <= By <= Ay1. intersection = (Ax, By) and distance is (x + y)
# stop searching once Ax > lowest distance

# Then iterate over wire A horizontal segments and compare similiarly. stop searching once Ay > lowest distance










# intersection rule:
# lines intersect if Ax0 <= Bx0 && Ax1 >= Bx1 && Ay0 >= By0 && Ay1 < By1
# lines intersect if Bx0 <= Ax0 && Bx1 >= Ax1 && By0 >= Ay0 && By1 < Ay1

# A: [(3, 2), (3, 5)]
# B: [(2, 3), (6, 3)]

# no match:
# A: [(0, 0), (8, 0)]
# B: [(3, 2), (3, 5)]

# build two lists of segments of the form [(x0, y0), (x1, y1)]  where x0 <= x1, y0 <= y1
# sort by first x coordinate (x0)
# Start with first segment of 1st list and start checking intersections