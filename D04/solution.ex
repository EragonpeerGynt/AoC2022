defmodule D04 do
	def part1(input) do
		input
		|> Enum.map(&any_subset/1)
		|> Enum.filter(fn x -> x == true end)
		|> Enum.count
	end

	def any_subset({elf1, elf2}) do
		is_subset_of(elf1, elf2) || is_subset_of(elf2, elf1)
	end

	def is_subset_of({subset_x, subset_y}, {main_x, main_y}) do
		subset_x >= main_x && subset_y <= main_y
	end

	def part2(input) do
		input
		|> Enum.map(&any_contains/1)
		|> Enum.filter(fn x -> x == true end)
		|> Enum.count
	end

	def any_contains({elf1, elf2}) do
		is_containing(elf1, elf2) || is_containing(elf2, elf1)
	end

	def is_containing({subset_x, subset_y}, {main_x, main_y}) do
		subset_x >= main_x && subset_x <= main_y
		||
		subset_y >= main_x && subset_y <= main_y
	end

	def parse_pairs([elf1, elf2]) do
		{parse_to_tuples(elf1), parse_to_tuples(elf2)}
	end

	def parse_to_tuples(input) do
		input
		|> String.split("-")
		|> Enum.map(fn x -> Integer.parse(x) |> then(fn {y, _} -> y end) end)
		|> then(fn [x,y] -> {x,y} end)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
		|> String.split("\n")
		|> Enum.map(fn x -> String.split(x, ",") end)
		|> Enum.map(&D04.parse_pairs/1)

		#D04.part1(input) |> IO.puts
		D04.part2(input) |> IO.puts
	end
end