defmodule Part1 do
	def solution(input) do
		input
		|> parse_input
	end

	def parse_input(input) do
		split_vertical(input)
		|> split_spaces()
		|> List.flatten
		|> Enum.filter(&find_length/1)
		|> Kernel.length
		|> IO.inspect
	end

	def find_length(input_word) do 
		[2,3,4,7] |> Enum.any?(&(String.length(input_word) == &1))
	end

	def split_vertical(input) do
		input
		|> Enum.map(&String.split(&1, "|", trim: true)) 
	end

	def split_spaces(input) do
		input
		|> Enum.map(fn [_,out] -> String.split(out, " ", trim: true) end)
	end
end

defmodule Part2 do
	def solution(input) do
		input
		|> parse_input
		|> Enum.map(&process_entry/1)
		|> Enum.sum
		|> IO.inspect
	end

	def process_entry({teacher, output}) do
		unique_map = get_uniqe_numbers_map(%{}, teacher)
		find_complex_number(output, unique_map)
		|> String.to_integer
	end

	def find_complex_number([], _) do
		""
	end

	def find_complex_number([head|output], map) do
		get_uniqe_numbers(head)
		|> case do
			x when x != nil -> x
			_ -> deduce_number(head,map)
		end
		|> Integer.to_string
		|> Kernel.<>(find_complex_number(output, map))
	end

	def deduce_number(number, map) do
		case length(number) do
			6 -> deduce_length_6(number, map)
			5 -> deduce_length_5(number, map)
		end
	end

	def deduce_length_6(number, map) do
		case length(map[4] -- number) do
			0 -> 9
			_ -> case length(map[1] -- number) do
				0 -> 0
				_ -> 6
			end
		end
	end

	def deduce_length_5(number, map) do
		case length(map[1] -- number) do
			0 -> 3
			_ -> case length(map[4] -- number) do
				1 -> 5
				_ -> 2
			end
		end
	end

	def get_uniqe_numbers_map(map, []) do
		map
	end

	def get_uniqe_numbers_map(map, [head|teacher]) do
		head
		|> get_uniqe_numbers
		|> add_to_dict(head, map)
		|> get_uniqe_numbers_map(teacher)
	end

	def get_uniqe_numbers(number) do
		case length(number) do
			2 -> 1
			3 -> 7
			4 -> 4
			7 -> 8
			_ -> nil
		end
	end

	def add_to_dict(nil, _, map) do
		map
	end

	def add_to_dict(key, value, map) do
		Map.put(map, key, value)
	end

	def parse_input(input) do
		input
		|> Part1.split_vertical
		|> Enum.map(&split_elements/1)
	end

	def split_elements([teacher, output]) do
		{teacher |> window_splitter, output |> window_splitter}
	end

	def window_splitter(window) do
		window
		|> String.split(" ", trim: true)
		|> Enum.map(&(String.split(&1, "", trim: true)))
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
		|> Input.split("\n")

		input
		|> Part1.solution

		input
		|> Part2.solution
	end
end