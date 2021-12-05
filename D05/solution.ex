defmodule Coordinates do
	defstruct [:x, :y]
	def initialize(x,y) do
		%Coordinates{x: String.to_integer(x), y: String.to_integer(y)}
	end
	def initialize() do
		%Coordinates{x: 0, y: 0}
	end
end

defmodule Layline do
	defstruct [:from, :to]
	def initialize() do
		%Layline{from: Coordinates.initialize, to: Coordinates.initialize}
	end
	def initialize(from_to) do
		[[x1, y1], [x2, y2]] = from_to
			|> String.split(" -> ", trim: true)
			|> Enum.map(&String.split(&1, ",", trim: true))
		%Layline{from: Coordinates.initialize(x1, y1), to: Coordinates.initialize(x2, y2)}
	end
	def get_not_straight(layline) do
		!get_straight(layline)
	end
	def get_straight(%Layline{from: %Coordinates{x: x1, y: y1}, to: %Coordinates{x: x2, y: y2}}) do
		case (x1 == x2 || y1 == y2) do
			n when n -> true
			_ -> false
		end
	end

	def get_not_diagonal(layline) do
		!get_diagonal(layline)
	end
	def get_diagonal(%Layline{from: %Coordinates{x: x1, y: y1}, to: %Coordinates{x: x2, y: y2}}) do
		x = x1-x2 |> Kernel.abs
		y = y1-y2 |> Kernel.abs
		case x do
			n when n == y -> true
			_ -> false
		end
	end
end

defmodule Part1 do
	def execute(input) do
		input = input
			|> Enum.reject(&Layline.get_not_straight/1)
		build_map(%{}, input)
			|> Map.to_list
			|> Enum.count(fn {_,x} -> x > 1 end)
			|> IO.puts
	end

	def build_map(map, []) do
		map
	end

	def build_map(map, [head|tail]) do
		{x1,x2} = Enum.min_max([head.from.x, head.to.x])
		{y1,y2} = Enum.min_max([head.from.y, head.to.y])
		rangex = Enum.to_list(x1..x2)
		rangey = Enum.to_list(y1..y2)
		rangex = if x1 != head.from.x, do: rangex |> Enum.reverse, else: rangex
		rangey = if y1 != head.from.y, do: rangey |> Enum.reverse, else: rangey
		dive_coordinate(rangex, rangey, map) 
			|> build_map(tail)
	end

	def dive_coordinate([x], y, map) do
		List.duplicate(x, length(y))
			|> Enum.zip(y)
			|> dive(map)
	end

	def dive_coordinate(x, [y], map) do
		x |> Enum.zip(List.duplicate(y, length(x)))
			|> dive(map)
	end

	def dive_coordinate(x, y, map) do
		x |> Enum.zip(y)
			|> dive(map)
	end

	def dive([], map) do
		map
	end

	def dive([head|tail], map) do
		map = case Map.get(map, head) do
			n when n != nil -> %{map | head => n+1}
			_ -> Map.put(map, head, 1)
		end
		dive(tail, map)
	end
end

defmodule Part2 do
	def execute(input) do
		input = input
			|> Enum.reject(fn x -> Layline.get_not_straight(x) && Layline.get_not_diagonal(x) end)
		Part1.build_map(%{}, input)
			|> Map.to_list
			|> Enum.count(fn {_,x} -> x > 1 end)
			|> IO.puts	
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
			|> Input.split("\n")
			|> Enum.map(&Layline.initialize/1)
			
		input
			|> Part1.execute

		input
			|> Part2.execute
	end
end