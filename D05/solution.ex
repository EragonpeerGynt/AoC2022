defmodule D05 do
	def part1(map, commands) do
		map
		|> process_commands(commands, 1)
		|> get_top_stack
	end

	def process_commands(map, [], _) do
		map
	end

	def process_commands(map, [command|commands], mode) do
		map
		|> execute_command(command, mode)
		|> process_commands(commands, mode)
	end

	def execute_command(map, command, mode) do
		execute_diver(map, command, map |> Enum.at(command[:f]-1), [], map |> Enum.at(command[:t]-1), command[:c], mode)
	end

	def execute_diver(map, command, [], add, stack, _, _) do
		finaliza_move(map, command, [], add, stack)
	end

	def execute_diver(map, command, [head|negative], add, stack, 0, _) do
		finaliza_move(map, command, [head|negative], add, stack)
	end
	
	def execute_diver(map, command, [head|negative], add, stack, count, mode) do
		case mode do
			1 -> execute_diver(map, command, negative, [head]++add, stack, count-1, mode)
			2 -> execute_diver(map, command, negative, add++[head], stack, count-1, mode)
		end
		
	end

	def finaliza_move(map, command, negative, add, stack) do 
		map
		|> List.replace_at(command[:t]-1, add++stack)
		|> List.replace_at(command[:f]-1, negative)
	end

	def part2(map, commands) do
		map
		|> process_commands(commands, 2)
		|> get_top_stack
	end

	def parse_storage(input) do
		input
		|> String.split("\n")
		|> Enum.reverse() |> tl() |> Enum.reverse()
		|> Enum.map(&process_storage_row/1)
		|> transpose
		|> Enum.map(&clean_storage/1)
	end

	def clean_storage(row) do
		row
		|> Enum.map(fn [x] -> x end)
		|> Enum.filter(fn x -> x != " " end)
	end

	def process_storage_row(input) do
		input
		|> String.graphemes
		|> tl()
		|> Enum.chunk_every(1, 4, :discard)
	end

	def transpose(rows) do
	  rows
	  |> List.zip
	  |> Enum.map(&Tuple.to_list/1)
	end

	def parse_commands(input) do
		input
		|> String.split("\n")
		|> Enum.map(&String.split(&1, " "))
		|> Enum.map(&extract_commands/1)
	end

	def extract_commands([_, count, _, from, _, to]) do
		%{c: count |> parse_int, f: from |> parse_int, t: to |> parse_int}
	end

	def parse_int(number) do
		number
		|> Integer.parse
		|> then(fn {x,_} -> x end)
	end

	def get_top_stack(input) do
		input
		|> Enum.map(fn [x|_] -> x end)
		|> Enum.join("")
	end
end

defmodule Main do
	def execute(day) do
		[map,commands] = Input.file(day) 
		|> String.split("\n\n")
		|> then(fn [x,y] -> [D05.parse_storage(x), D05.parse_commands(y)] end)

		D05.part1(map, commands) |> IO.puts
		D05.part2(map, commands) |> IO.puts
	end
end
