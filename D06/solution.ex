defmodule D06 do
	def part1(input) do
		input
		|> process(4)
	end

	def process(input, distinct_marker) do
		input
		|> Enum.chunk_every(distinct_marker, 1, :discard)
		|> inspect_unique(0)
		|> then(fn x -> x+distinct_marker end)
	end

	def inspect_unique([current|remaining], index) do
		if current |> Enum.count != current |> Enum.uniq |> Enum.count do
			inspect_unique(remaining, index+1)
		else
			index
		end
	end

	def part2(input) do
		input
		|> process(14)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.graphemes

		D06.part1(input) |> IO.puts
		D06.part2(input) |> IO.puts
	end
end
