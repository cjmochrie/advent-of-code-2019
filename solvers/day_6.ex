defmodule Day6 do
  defmodule Planet do
    defstruct parent: nil, children: []
  end

  def solve_1(input) do
    orbits = Enum.map(input, &parse_orbit/1)
    planets = build_map(%{}, orbits)
    { _, root } = root(planets)
    count_orbits(root, planets, 0)
  end

  def solve_2(input) do
    orbits = Enum.map(input, &parse_orbit/1)
    planets = build_map(%{}, orbits)
    count_transfers(Map.fetch!(planets, "YOU"), "SAN", planets, -1)
  end

  def count_transfers(planet, destination, planets, transfers_so_far) do
    case descendants(planet, destination, planets) do
      { :ok, steps } -> transfers_so_far + steps
      nil -> count_transfers(
               Map.fetch!(planets, planet.parent),
               destination,
               planets,
               transfers_so_far + 1
             )
    end
  end

  def descendants(%{ :children => children }, destination, planets) do
    Enum.find_value(
      children,
      nil,
      fn(child) ->
        if child == destination do
          { :ok, 0 }
        else
          case descendants(Map.fetch!(planets, child), destination, planets) do
            { :ok, steps } -> { :ok, 1 + steps }
            nil -> nil
          end
        end
      end
    )
  end

  def descendants(%{ :children => [] }, _, _) do
    nil
  end

  def count_orbits(%{ :children => children }, planets, level) do
    Enum.map(
      children,
      fn(child) -> 1 + level + count_orbits(
        Map.fetch!(planets, child),
        planets,
        level + 1
      ) end
    ) |> Enum.sum
  end

  def count_orbits(%{ :children => [] }, _, _) do
    0
  end

  def root(planets) do
    Enum.find(
      planets,
      nil,
      fn({ _, planet }) -> !is_nil(planet) and is_nil(planet.parent) end
    )
  end

  def build_map(planets, [[ parent, child] | orbits]) do
    Map.update(
      planets,
      parent,
      %Planet{ children: [child] },
      fn(parent) -> update_parent(parent, child) end)
    |> Map.update(
      child,
      %Planet{ parent: parent },
      fn(child) -> update_child(child, parent) end)
    |> build_map(orbits)
  end

  def build_map(planets, []) do
    planets
  end

  def parse_orbit(raw) do
    String.split(raw, ")")
  end

  def update_parent(planet, child) do
    %{ planet | children: [child | planet.children] }
  end

  def update_child(planet, parent) do
    %{ planet | parent: parent }
  end

end


# Map of strings to strings
# if string is in map, append a new value to the list

