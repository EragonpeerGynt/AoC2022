defmodule D do
	def part1(input) do
		input
	end

	def part2(input) do
		input
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)

		D.part1(input) |> IO.puts
		D.part2(input) |> IO.puts
	end
end