defmodule Subposition do
	defstruct [:horizontal, :vertical]
	def getInitial do
		%Subposition{horizontal: 0 , vertical: 0}
	end
end

defmodule Orientation do
	defstruct [:horizontal, :vertical, :orientation]
	def getInitial do
		%Orientation{horizontal: 0, vertical: 0, orientation: 0}
	end
end

defmodule Command do
	defstruct [:direction, :length]
end

defmodule D02 do
	def part1([], position) do
		position
	end
	def part1([%Command{direction: "forward", length: len}|commands], position) do
		position = %{position | horizontal: position.horizontal + len}
		part1(commands, position)
	end
	def part1([%Command{direction: "up", length: len}|commands], position) do
		position = %{position | vertical: position.vertical - len}
		part1(commands, position)
	end
	def part1([%Command{direction: "down", length: len}|commands], position) do
		position = %{position | vertical: position.vertical + len}
		part1(commands, position)
	end
	def part1Parse(command) do
		splited = String.split(command, " ", trim: true)
		{len, _} = Enum.at(splited, 1) |> Integer.parse()
		%Command{direction: Enum.at(splited, 0), length: len}
	end

	def part2([], position) do
		position
	end
	def part2([%Command{direction: "forward", length: len}|commands], position) do
		position = %{position | horizontal: position.horizontal + len, vertical: position.vertical + (position.orientation * len)}
		part2(commands, position)
	end
	def part2([%Command{direction: "up", length: len}|commands], position) do
		position = %{position | orientation: position.orientation - len}
		part2(commands, position)
	end
	def part2([%Command{direction: "down", length: len}|commands], position) do
		position = %{position | orientation: position.orientation + len}
		part2(commands, position)
	end
end

defmodule Main do 
	def execute(day) do
		input = Input.file(day) 
			|> Input.split("\n")
			|> Enum.map(fn x -> D02.part1Parse(x) end)

		position1 = Subposition.getInitial
		part1Object = input |> D02.part1(position1) 
		part1Object.horizontal*part1Object.vertical |> IO.puts
		position2 = Orientation.getInitial
		part2Object = input |> D02.part2(position2)
		part2Object.horizontal*part2Object.vertical |> IO.puts
	end
end
