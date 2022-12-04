defmodule D01 do
	def part1(input) do
		input
		|> Enum.map(fn x -> sumCalories(x) end)
		|> Enum.max
	end

	def sumCalories(input) do
		input
		|> String.split("\n")
		|> Enum.map(fn x -> Integer.parse(x) end)
		|> Enum.map(fn {x, _} -> x end)
		|> Enum.sum
	end

	def part2(input) do
		input
		|> Enum.map(fn x -> sumCalories(x) end)
		|> Enum.sort(:desc)
		|> Enum.slice(0..2)
		|> Enum.sum
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) |> String.split("\n\n")

		D01.part1(input) |> IO.puts
		D01.part2(input) |> IO.puts
	end
end
