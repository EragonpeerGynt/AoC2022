defmodule Part1 do
	def solution(input) do
		build_dictionary(%{}, input)
		|> cycle_day(0, 80)
		|> count_fish()
		|> IO.inspect
	end

	def build_dictionary(dictionary, []) do
		dictionary
		|> fix_dictionary(-1)
	end
	def build_dictionary(dictionary, [head|tail]) do
		case Map.get(dictionary, head) do
			n when n != nil -> %{dictionary | head => n+1}
			_ -> Map.put(dictionary, head, 1)
		end
		|> build_dictionary(tail)
	end
	def fix_dictionary(dictionary, day) do
		if day > 8 do
			dictionary
		else
			case Map.get(dictionary, day) do
				n when n != nil -> dictionary
				_ -> Map.put(dictionary, day, 0)
			end
			|> fix_dictionary(day+1)
		end
	end

	def cycle_day(dictionary, day, limit) do
		if (day >= limit) do
			dictionary
		else
			process_day(dictionary)
			|> cycle_day(day+1, limit)
		end
	end

	def process_day(dictionary) do
		dictionary = dictionary |>
			day_diver(0)
		multiplier = Map.get(dictionary, -1)
		dictionary = %{dictionary | 6 => Map.get(dictionary, 6) + multiplier}
		%{dictionary | 8 => multiplier}
	end
	def day_diver(dictionary, index) do
		if index == 9 do
			dictionary
		else
			%{dictionary | index-1 => Map.get(dictionary, index)}
			|> day_diver(index+1)
		end
	end

	def count_fish(dictionary, day \\ 0) do
		if day > 8 do
			0
		else
			Map.get(dictionary, day) + count_fish(dictionary, day+1)
		end
	end
end

defmodule Part2 do
	def solution(input) do
		Part1.build_dictionary(%{}, input)
		|> Part1.cycle_day(0, 256)
		|> Part1.count_fish()
		|> IO.inspect
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
		|> Input.split(",")
		|> Enum.map(&String.to_integer/1)

		input 
		|> Part1.solution
		
		input
		|> Part2.solution
	end
end