defmodule D08 do
	def part1(input) do
 		max_edge = {max_x, max_y} = input |> find_max_edge |> IO.inspect
		flat_map = input
  		|> Map.to_list
  		hidden_trees = flat_map
		|> Enum.filter(fn {point, _} -> not_edge(point, max_edge) end)
		|> Enum.filter(fn x -> not_highest(x, flat_map) end)
  		|> Enum.count

 		((max_x+1)*(max_y+1))-hidden_trees
	end

 	def not_highest(current, height_map) do
  		not_highest(current, height_map, "x+")
		&& not_highest(current, height_map, "x-")
		&& not_highest(current, height_map, "y+")
		&& not_highest(current, height_map, "y-")
  	end

   	def not_highest({{x, y}, height}, height_map, "x+") do
		height_map
  		|> Enum.filter(fn {{p_x, p_y}, p_h} -> p_x > x && p_y == y && p_h >= height end)
		|> Enum.count > 0
 	end

  	def not_highest({{x, y}, height}, height_map, "x-") do
		height_map
  		|> Enum.filter(fn {{p_x, p_y}, p_h} -> p_x < x && p_y == y && p_h >= height end)
		|> Enum.count > 0
 	end

  	def not_highest({{x, y}, height}, height_map, "y+") do
		height_map
  		|> Enum.filter(fn {{p_x, p_y}, p_h} -> p_x == x && p_y > y && p_h >= height end)
		|> Enum.count > 0
 	end

  	def not_highest({{x, y}, height}, height_map, "y-") do
		height_map
  		|> Enum.filter(fn {{p_x, p_y}, p_h} -> p_x == x && p_y < y && p_h >= height end)
		|> Enum.count > 0
 	end

 	def find_max_edge(input) do
		input
  		|> Map.to_list
		|> Enum.max
  		|> then(fn {x, _} -> x end)
  	end

   	def not_edge({x,y}, {edge_x, edge_y}) do
		not_edge(x, edge_x) && not_edge(y, edge_y)
 	end

  	def not_edge(c, edge_c) do
		c != 0 && c != edge_c
   	end

	def part2(input) do
 		max_edge = input |> find_max_edge
 		input
	 	|> Enum.map(fn {point, height} -> 
   			get_all_lines(input, point, max_edge)
	  		|> Enum.map(fn x -> dive_eyesight(x, height, 0) end)
	 		|> Enum.product
   			end)
	  	|> Enum.max
	end

 	def dive_eyesight([], _, trees_viewed), do: trees_viewed

 	def dive_eyesight([child_height|remainder], height, trees_viewed) do
		if (height > child_height) do
  			dive_eyesight(remainder, height, trees_viewed+1)
		else
			trees_viewed+1
  		end
  	end

 	def get_all_lines(map, point, {max_x, max_y}) do
  		# Arrays of all "nerby" trees
		[
  			find_line(map, point, "x"),
	 		find_line(map, point, "x", max_x),
			find_line(map, point, "y"),
   			find_line(map, point, "y", max_y)
		]
  	end

   	def line_generator(map, relative_index, map_function) do
		# Error if you leave 0 in since that is same element...
  		relative_index
		|> Enum.filter(fn x -> x != 0 end)
  		|> Enum.reduce([], fn x, acc -> map_index_height(map, x, acc, map_function) end)
 	end

  	def map_index_height(map, index_distance, previous_heights, map_function) do
		map 
  		|> Map.get(map_function.(index_distance))
		|> then(fn x -> [x|previous_heights] end)
	end

 	# needs to be - coordinate range. If you use reverse you don't get negative nubers...
 	def find_line(map, {x, y}, "x"), 
  		do: line_generator(map, -x..0, fn distance -> {x + distance, y} end)
   	def find_line(map, {x, y}, "y"), 
		do: line_generator(map, -y..0, fn distance -> {x, y + distance} end)
  	# Reverse range since we uset head operator in builder, which gives first processed element as last
  	def find_line(map, {x, y}, "x", max_x), 
   		do: line_generator(map, 0..(max_x - x) |> Enum.reverse(), fn distance -> {x + distance, y} end)
  	def find_line(map, {x, y}, "y", max_y), 
   		do: line_generator(map, 0..(max_y - y) |> Enum.reverse(), fn distance -> {x, y + distance} end)
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")
		|> Enum.map(&String.graphemes/1)
  		|> Enum.map(fn x -> x |> Enum.map(&String.to_integer/1) end)
  		|> Maping.create_map()

		#D08.part1(input) |> IO.puts
		D08.part2(input) |> IO.puts
	end
end