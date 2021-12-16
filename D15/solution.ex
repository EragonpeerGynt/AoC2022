defmodule Old do
	def solution(input) do
		dive(
			%{{0,0} => {0, get_manhattan({0,0}, input |> get_last_key)}}, 
			input, 
			%{}, 
			input |> get_last_key)
		|> IO.inspect
	end

	def dive(distance, map, visited, max_key) do
		case get_current_min(distance, visited) do
			{coor, value} when coor == max_key -> value
			{coor, _} -> add_neighbours(coor, map, distance, max_key)
			|> dive(map, Map.put(visited, coor, 0), max_key)
		end
	end

	def add_neighbours({x,y} = node, map, distance, max_key) do
		for(
			dx <- (x-1)..(x+1),
			dy <- (y-1)..(y+1),
			node != {dx,dy} and (dx == x or dy == y),
			do: {dx,dy}
		)
		|> Enum.reject(fn new_node -> map[new_node] == nil end)
		|> Enum.reduce(distance, fn new_node, acc -> 
			case find_distance(new_node, map[new_node]+(acc[node] |> then(fn {a,_} -> a end)), acc) do
				{true, value} -> Map.put(acc, new_node, {value, value+get_manhattan(new_node, max_key)})
				{false, _} -> acc
			end
		end)
	end

	def find_distance(node, new_value, distance) do
		case distance[node] do
			nil -> {true, new_value}
			{ac,_} -> if ac < new_value do
				{false, nil}
			else
				{true, new_value}
			end
		end
	end

	def get_current_min(distance, visited) do
		distance
		|> Map.to_list
		|> Enum.reject(fn {coor, _} -> visited[coor] != nil end)
		|> Enum.sort_by(fn {_,{_,val}} -> val end)
		|> then(fn [first|_] -> first end)
	end

	def get_last_key(map) do
		map
		|> Map.to_list
		|> then(fn m -> 
			{
				m 
				|> Enum.map(fn {{x,_},_} -> x end)
				|> Enum.sort(:desc)
				|> then(fn [x|_] -> x end),
				m 
				|> Enum.map(fn {{_,y},_} -> y end)
				|> Enum.sort(:desc)
				|> then(fn [y|_] -> y end)
			} end)
	end

	def get_manhattan({x1,y1},{x2,y2}) do
		(get_distance(x1,x2) + get_distance(y1,y2))
	end

	def get_distance(x,y) do
		Enum.min_max([x,y])
		|> then(fn {l,h} -> h-l end)
	end
end

defmodule Part1 do
	def add_to_queue([head|tail], {coor, val
end

defmodule Part2 do
	def solution(input) do
		input
		|> expand
		|> Part1.solution
	end

	def expand(input) do
		base_max = input 
		|> Part1.get_last_key
		|> then(fn {x, y} -> {x+1, y+1} end)
		
		base_max
		|> then(fn {max_x, max_y} ->
			for(
				x <- 0..(max_x*5-1),
				y <- 0..(max_y*5-1),
				x >= max_x or y >= max_y,
				do: {x,y}
			)
		end)
		|> then(fn coor -> dive_extend(input, coor, base_max) end)
	end

	def dive_extend(map, [], _) do
		map
	end

	def dive_extend(map, [coor|tail], base_max) do
		get_extended_value(map, coor, base_max)
		|> dive_extend(tail, base_max)
	end

	def get_extended_value(input, {x,y} = c, new_c) do
		case (input[new_val_calc(c, new_c)] + 1) do
			n when n == 10 -> 1
			n -> n
		end
		|> then(fn val -> Map.put(input, {x,y}, val) end)
	end

	def new_val_calc({x, y}, {b_x, b_y}) do
		if x < b_x do
			{x, y-b_y}
		else
			{x-b_x, y}
		end
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n", trim: true)
		|> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.map(&String.to_integer/1) end)
		|> Maping.create_map

		#input
		#|> Part1.solution

		input
		|> Part2.solution
	end
end