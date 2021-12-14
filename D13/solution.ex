defmodule Part1 do
	def solution({map, [first|_]}) do
		process_comm(map, first) |> Enum.uniq |> Enum.count |> IO.inspect
	end

	def dive_commands(map, []) do
		map
	end

	def dive_commands(map, [head_command|tail]) do
		map |> process_comm(head_command) |> Enum.uniq |> dive_commands(tail)
	end

	def process_comm([], _) do	
		[]
	end

	def process_comm([{x,y}|tail], {"fold along y", dis} = comm) do
		[{x, mirror_calculator(y, dis)}|process_comm(tail, comm)]
	end

	def process_comm([{x,y}|tail], {"fold along x", dis} = comm) do
		[{mirror_calculator(x, dis), y}|process_comm(tail, comm)]
	end

	def mirror_calculator(num, mirror) do
		(mirror - abs(num - mirror)) |> trunc
	end

	def format_map(map) do
		map 
		|> Enum.map(fn unsplited -> String.split(unsplited, ",", trim: true)
			|> then(fn [x,y] -> {x |> String.to_integer, y |> String.to_integer} end) end)
	end
	def format_comm(comm) do
		comm 
		|> Enum.map(fn unsplited -> String.split(unsplited, "=", trim: true)
			|> then(fn [x,y] -> {x,y |> String.to_integer} end) end)
	end
end

defmodule Part2 do
	def solution({map, comm}) do
		Part1.dive_commands(map, comm) |> Enum.uniq |> visualiser
	end

	def visualiser(map) do
		max_x = map |> Enum.map(fn {x,_} -> x end) |> Enum.max
		max_y = map |> Enum.map(fn {_,y} -> y end) |> Enum.max
		draw_y_axis(map, 0, 0, max_x, max_y)
	end

	def draw_y_axis(map, x, y, max_x, max_y) do
		if y <= max_y do
			draw_x_axis(map, x, y, max_x, max_y)
			IO.puts ""
			draw_y_axis(map, x, y+1, max_x, max_y)
		end
	end

	def draw_x_axis(map, x, y, max_x, max_y) do
		if x <= max_x do
			case (map |> Enum.any?(fn coor -> coor == {x,y} end)) do
				true -> IO.write "*"
				false -> IO.write " "
			end
			draw_x_axis(map, x+1, y, max_x, max_y)
		end
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n\n", trim: true)
		|> Enum.map(&String.split(&1, "\n", trim: true))
		|> then(fn [map, comm] -> {map |> Part1.format_map, comm |> Part1.format_comm} end)

		input
		|> Part1.solution
		
		input
		|> Part2.solution
	end
end