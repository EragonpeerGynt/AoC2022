#[del: _, ins: _, eq: both, del: _, ins: _] = List.myers_difference(a,b)
defmodule D03 do
	def part1(input) do
		mappings = generate_translator()
		input
		|> Enum.map(fn x -> split_list(x) end)
		|> Enum.map(fn {x,y} -> same_part(Enum.uniq(x),Enum.uniq(y)) end)
		|> Enum.map(fn x -> value_parse(x, mappings) end)
		|> Enum.sum
	end

	def same_part(bag1, bag2) do
		List.myers_difference(bag1, bag2)
		|> Keyword.take([:eq])
		|> equilizer([])
	end

	def equilizer([], current) do
		current
	end

	def equilizer([{:eq, input}|remaining], current) do
		equilizer(remaining, current ++ input)
	end
	
	def split_list(input) do
		Enum.split(input,div(Enum.count(input),2))
	end

	def value_parse([value], translator) do
		translator[:binary.first(value)]
	end

	def generate_translator() do
		Map.new(
			Enum.zip(Enum.to_list(?a..?z)++Enum.to_list(?A..?Z),
			Enum.to_list(1..52)))
	end

	def part2(input) do
		mappings = generate_translator()
		input
		|> Enum.map(fn x -> Enum.sort(Enum.uniq(x)) end)
		|> Enum.chunk_every(3)
		|> Enum.map(fn x -> find_tripple(x) end)
		|> Enum.map(fn x -> value_parse(x, mappings) end)
		|> Enum.sum
	end

	def find_tripple([bag1,bag2,bag3]) do
		bag1
		|> same_part(bag2)
		|> same_part(bag3)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
		|> String.split("\n")
		|> Enum.map(fn x -> String.graphemes(x) end)

		D03.part1(input) |> IO.puts
		D03.part2(input) |> IO.puts
	end
end