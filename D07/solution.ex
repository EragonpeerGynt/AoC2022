defmodule D07 do
	def part1(input) do
		input
  		|> get_structure
		|> size_calculator
  		|> then(fn {_, x} -> x end)
		|> Enum.filter(fn x -> x <= 100000 end)
  		|> Enum.sum
 	end

  	def part2(input) do
		{total, sizes} = input
  		|> get_structure
		|> size_calculator

		max_ssd = 70000000
  		required_ssd = 30000000
		missing_ssd = required_ssd - (max_ssd - total)

  		sizes
		|> Enum.sort(:asc)
  		|> Enum.find(fn x -> x >= missing_ssd end)
	end   	

	def get_structure(input) do
		input
  		|> Enum.reduce({["/"], %{"/" => %{}}}, fn command, {path, tree} -> process(command, path, tree) end)
 		|> then(fn {_, x} -> x end)
  	end

  	def process(<<"$ cd ..">>, path, tree) do
		{path |> Enum.drop(-1), tree}
   	end

 	def process(<<"$ cd /">>, _, tree) do
  		{["/"], tree}
  	end

   	def process(<<"$ cd ", newdir::binary>>, path, tree) do
		{path ++ [newdir], tree}
	end

 	def process(<<"$ ls", _::binary>>, path, tree) do
		{path, tree}
  	end

   	def process(<<"dir ", dirname::binary>>, path, tree) do
		{path, put_in(tree, path ++ [dirname], %{})}
 	end

  	def process(file, path, tree) do
		String.split(file)
  		|> then(fn [size,name] -> {path, put_in(tree, path ++ [name], String.to_integer(size))} end)
   	end

 	def size_calculator(tree) do
		tree
  		|> Map.values
		|> Enum.reduce({0, []}, fn element,operator -> get_size(element, operator) end)
  	end

   	def get_size(folder, {total, subsizes}) when is_map(folder) do
		folder
  		|> size_calculator
		|> then(fn {folder_size, folder_subsizes} -> {total + folder_size, [folder_size|folder_subsizes] ++ subsizes} end)
 	end

  	def get_size(size, {total, subsizes}) do
		{total + size, subsizes}
   	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
  		|> String.split("\n")

		#D07.part1(input) |> IO.puts
		D07.part2(input) |> IO.puts
	end
end
