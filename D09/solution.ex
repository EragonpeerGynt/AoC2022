defmodule Part1 do
	def solution(input) do
		mask = [{1,0}, {0,1}, {-1,0}, {0,-1}]
		check_all_quadrants(Map.to_list(input), mask, input)
		|> Enum.map(fn {value, _} -> value+1 end)
		|> Enum.sum()
		|> IO.inspect
	end

	def format_input(input) do
		format_input(%{}, input, 0, 0)
	end

	def check_all_quadrants([], _, _) do
		[]
	end

	def check_all_quadrants([{coordinates, value}|tail], mask, map) do
		case check_surrounding?(mask, coordinates, value, map) do
			true -> [{value, coordinates} | check_all_quadrants(tail, mask, map)]
			_ -> check_all_quadrants(tail, mask, map)
		end
	end

	def check_surrounding?([], _, _, _) do
		true
	end

	def check_surrounding?([{mx,my}|tail], {x,y}=center, value, map) do
		case map[{x+mx, y+my}] do
			n when value < n -> check_surrounding?(tail, center, value, map)
			nil -> check_surrounding?(tail, center, value, map)
			_ -> false
		end
	end

	def format_input(map, [], _, _) do
		map
	end

	def format_input(map, [head|tail], x, y) when is_list(head) do
		format_input(map, head, x, y)
		|> format_input(tail, x, y+1)
	end

	def format_input(map, [head|tail], x, y) do
		Map.put(map, {x,y}, head)
		|> format_input(tail, x+1, y)
	end
end

defmodule Part2 do
	def solution(input) do
		[{1,0}, {0,1}, {-1,0}, {0,-1}]
		|> then(
			fn x -> Part1.check_all_quadrants(Map.to_list(input), x, input)
			|> Enum.map(fn {_, c} -> c end)
			|> Enum.map(&basin_search([&1], input, x))		
			end
		)
		|> Enum.map(&length/1)
		|> Enum.sort(:desc)
		|> Enum.take(3)
		|> Enum.product()
		|> IO.inspect
	end

	def basin_search(_, _, _, accumulator \\ [])

	def basin_search([], _, _, accumulator) do
		accumulator
		|> Enum.uniq
	end

	def basin_search([head|tail], map, mask, accumulator) do
		apply_mask(mask, head)
		|> Enum.filter(fn x -> Map.get(map, x, -1) > Map.get(map, head) && Map.get(map, x, -1) < 9 end)
		|> Kernel.++(tail)
		|> basin_search(map, mask, [head | accumulator])
	end

	def apply_mask([], _) do
		[]
	end

	def apply_mask([{xm,ym}|mask], {x,y}=base) do
		[{x+xm,y+ym}|apply_mask(mask,base)]
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n", trim: true)
		|> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.map(&String.to_integer/1) end)
		|> Part1.format_input

		input
		|> Part1.solution

		input
		|> Part2.solution
	end
end