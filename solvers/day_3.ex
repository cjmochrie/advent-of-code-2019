defmodule Day3 do
  def solve_1([wire_a, wire_b]) do
    { a_horizontal, a_vertical } = segments([], [], { 0, 0 }, parse_input(wire_a))
    { b_horizontal, b_vertical } = segments([], [], { 0, 0 }, parse_input(wire_b))
    sorted_a_horizontal = Enum.sort_by(a_horizontal, fn({ x, _, _}) -> abs(x) end, &<=/2)
    sorted_a_vertical = Enum.sort_by(a_vertical, fn({ y, _, _}) -> abs(y) end, &<=/2)
    sorted_b_horizontal = Enum.sort_by(b_horizontal, fn({ x, _, _}) -> abs(x) end, &<=/2)
    sorted_b_vertical = Enum.sort_by(b_vertical, fn({ y, _, _}) -> abs(y) end, &<=/2)
    closest_h_v = closest_intersection(sorted_a_horizontal, sorted_b_vertical, sorted_b_vertical, 9999999999)
    closest_intersection(sorted_a_vertical, sorted_b_horizontal, sorted_b_horizontal, closest_h_v)
  end

  def closest_intersection([a_first | a_rest], [b_first | b_rest], all_b, shortest) do
    cond do
      beyond_shortest_distance(a_first, shortest) -> shortest
      beyond_shortest_distance(b_first, shortest) -> closest_intersection(a_rest, all_b, all_b, shortest)
      true -> case segment_intersection(a_first, b_first) do
        { :ok, distance } -> closest_intersection([a_first | a_rest], b_rest, all_b, Enum.min([distance, shortest]))
        { :no } -> closest_intersection([a_first | a_rest], b_rest, all_b, shortest)
      end
    end
  end

  def closest_intersection([_ | a_rest], [], all_b, shortest) do
    IO.puts "Ran out of segments in B. shortest #{shortest}"
    closest_intersection(a_rest, all_b, all_b, shortest)
  end

  def closest_intersection([], _, _, shortest) do
    IO.puts "Ran out of segments in A. shortest #{shortest}"
    shortest
  end

  def beyond_shortest_distance({ x, _, _ }, shortest) do
    abs(x) > shortest
  end

  def segment_intersection({ x, y0, y1 }, { y, x0, x1 }) do
    if x0 <= x and x <= x1 and y0 < y and y < y1 do
      { :ok, abs(x) + abs(y) }
    else
      { :no }
    end
  end

  def segments(horizontal, vertical, { x, y }, [ { direction, distance } | rest ]) do
    case direction do
      "U" -> segments(horizontal, [ { x, y, y + distance } | vertical ], { x, y + distance }, rest)
      "D" -> segments(horizontal, [ { x, y - distance, y } | vertical ], { x, y - distance }, rest)
      "L" -> segments([ { y, x - distance, x } | horizontal ], vertical, { x - distance, y }, rest)
      "R" -> segments([ { y, x, x + distance} | horizontal ], vertical, { x + distance, y }, rest)
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