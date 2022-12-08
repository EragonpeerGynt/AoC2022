defmodule D08 do
	def part1(input) do
 		max_edge = input |> find_max_edge
		input
  		|> Enum.count(fn x -> is_visible_on_any(x, input, max_edge) end)
	end

 	def is_visible_on_any({point, height}, map, {max_x, max_y}) do
		is_visible_in_range(height, find_line(map, point, "x"))
  		|| is_visible_in_range(height, find_line(map, point, "x", max_x))
		|| is_visible_in_range(height, find_line(map, point, "y"))
   		|| is_visible_in_range(height, find_line(map, point, "y", max_y))
  	end

   	def is_visible_in_range(height, tree_line), do: tree_line |> Enum.all?(fn x -> x < height end)

 	def find_max_edge(input) do
		input
  		|> Map.to_list
		|> Enum.max
  		|> then(fn {x, _} -> x end)
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

		D08.part1(input) |> IO.puts
		D08.part2(input) |> IO.puts
	end
end