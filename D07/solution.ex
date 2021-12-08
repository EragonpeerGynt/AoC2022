defmodule Part1 do
	def solve(input) do
		{min,max} = Enum.min_max(input)
		Enum.to_list(min..max)
		|> Enum.map(fn fuel -> Enum.reduce(input, 0, fn x,acc -> abs(x-fuel) + acc end) end)
		|> Enum.min()
		|> IO.inspect
	end
end

defmodule Part2 do
	def solve(input) do
		{min,max} = Enum.min_max(input)
		Enum.to_list(min..max)
		|> Enum.map(fn fuel -> Enum.reduce(input, 0, fn x,acc -> quick_maths(abs(x-fuel)) + acc end) end)
		|> Enum.min()
		|> IO.inspect
	end

	def quick_maths(x) do
		:math.pow(x,2) + x |> Kernel.*(0.5) |> round
	end
end


defmodule Main do
	def execute(day) do
		input = Input.file(day) 
		|> Input.split(",")
		|> Enum.map(&String.to_integer/1)

		input
		|> Part1.solve

		input
		|> Part2.solve
	end
end