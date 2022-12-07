defmodule D07 do
	def part1(input) do
 		input
   		|> get_structure
   		|> build_sizes
   		|> then(fn {x, _, _, _} -> x end)
	 	|> Enum.filter(fn {_, x} -> x <= 100000 end)
   		|> Enum.map(fn {_, x} -> x end)
	 	|> Enum.sum
	end

 	def get_structure(input) do
		input
   		|> Enum.reduce(
	 		%{folders: MapSet.new(), routes: MapSet.new(), files: MapSet.new(), dir: "/"},
			fn x, acc -> process_line(x, acc) end)
	end

	def build_sizes(state = %{routes: routes, files: files}) do
		dive_calculate({[], 0, routes |> MapSet.to_list, files |> MapSet.to_list}, "/")
 	end

  	def dive_calculate({sizes, sum_size, routes, files}, dir) do
		file_size = files
		|> Enum.filter(fn {x, _} -> x == dir end)
		|> Enum.map(fn {_, {_,x}} -> x end)
		|> Enum.sum

  		remaining_routes = routes
		|> Enum.filter(fn {x,_} -> x != dir end)

  		{sizes, sum_size, remaining_routes, remaining_files} = routes
		|> Enum.filter(fn {x,_} -> x == dir end)
		|> Enum.map(fn {_,x} -> x end)
		|> Enum.reduce({sizes, 0, remaining_routes, files}, fn x,acc -> dive_calculate(acc, x) end)
	 	
		{sizes ++ [{dir, file_size + sum_size}], file_size + sum_size, remaining_routes , remaining_files}
	end

	# process when input/command
 	def process_line(["$"|commands], state) do
		process_command(commands, state)
  	end

   	def process_command(["ls"|_], state) do
		state
 	end

  	def process_command(["cd"|[".."]], state) do
		find_previous_dir(state)
 	end

  	def process_command(["cd"|["/"]], state = %{folders: folders}) do
		%{state | dir: "/", folders: folders |> MapSet.put("/")}
 	end

  	def find_previous_dir(state = %{dir: "/"}) do
  		%{state | dir: "/"}
   	end

  	def find_previous_dir(state = %{routes: routes, dir: dir}) do
		newdir = routes	
  		|> MapSet.to_list 
		|> Enum.filter(fn {_, x} -> x == dir end) 
  		|> hd()
		|> then(fn {x, _} -> x end)
  		%{state | dir: newdir}
   	end

  	def process_command(["cd"|[dir]], state) do
		insert_dir(dir, state)
  		|> then(fn x -> %{x | dir: dir} end)
 	end

	# process when output
   	def process_line(output, state) do
		process_output(output, state)
  	end

	def process_output(["dir", dirname], state) do
		insert_dir(dirname, state)
 	end

  	def insert_dir(dirname, state = %{folders: folders, routes: routes, dir: dir}) do
   		%{state | folders: folders |> MapSet.put(dirname), routes: routes |> MapSet.put({dir, dirname})}
   	end

  	def process_output([filesize, file], state = %{files: files, dir: dir}) do
		%{state | files: files |> MapSet.put({dir, {file, filesize |> parse_int}})}
 	end

  	def parse_int(number) do
		number
		|> Integer.parse
		|> then(fn {x,_} -> x end)
	end

	def part2(input) do
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
  		|> String.split("\n")
		|> Enum.map(&String.split(&1, " "))

		D07.part1(input) |> IO.puts
		#D07.part2(input) |> IO.puts
	end
end
