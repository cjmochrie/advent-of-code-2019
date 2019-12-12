defmodule Day8 do
  @black "0"
  @white "1"
  @transparent "2"

  def solve_1(input) do
    { width, _ } = IO.gets("Width?") |> Integer.parse
    { height, _ } = IO.gets("Height?") |> Integer.parse
    dimensions = { width, height }
    layers = extract_layers(input, dimensions)
    layers
    |> fewest_digits
    |> mult_ones_and_twos
  end

  def solve_2(input) do
    { width, _ } = IO.gets("Width?") |> Integer.parse
    { height, _ } = IO.gets("Height?") |> Integer.parse
    dimensions = { width, height }
    extract_layers(input, dimensions)
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&render_pixel/1)
    |> Enum.chunk(width)
    |> Enum.map(fn row -> Enum.join(row, "") end)
    |> Enum.join("\n")
  end

  def render_pixel([ @black | _]), do: @black
  def render_pixel([ @white | _]), do: @white
  def render_pixel([]), do: @transparent
  def render_pixel([ @transparent | rest]), do: render_pixel(rest)

  def extract_layers(data, { width, height }) do
    Enum.chunk(data, width * height)
  end

  def mult_ones_and_twos(layer) do
    counter = layer |> count_digits
    { :ok, ones } = Map.fetch(counter, "1")
    { :ok, twos } = Map.fetch(counter, "2")
    ones * twos
  end

  def fewest_digits(layers, digit \\ "0") do
    layers
    |> Enum.min_by fn layer ->
      counter = count_digits(layer)
      case Map.fetch(counter, digit) do
        { :ok, count } -> count
        :error -> 0
      end
    end
  end

  def count_digits(layer) do
    Enum.reduce(
      layer,
      %{},
      fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end
    )
  end
end


#  # ###  #  # #### ###
#  # #  # #  # #    #  #
#  # ###  #  # ###  #  #
#  # #  # #  # #    ###
#  # #  # #  # #    #
 ##  ###   ##  #    #