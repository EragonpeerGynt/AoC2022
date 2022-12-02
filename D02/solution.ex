defmodule D02 do
	def part1(input) do
		input
		|> Enum.map(fn x -> splitter(x) end)
		|> Enum.map(fn x -> winner(x) end)
		|> Enum.sum
	end

	def winner(%{e: "A", m: "X"}), do: 1+3
	def winner(%{e: "A", m: "Y"}), do: 2+6
	def winner(%{e: "A", m: "Z"}), do: 3+0
	def winner(%{e: "B", m: "X"}), do: 1+0
	def winner(%{e: "B", m: "Y"}), do: 2+3
	def winner(%{e: "B", m: "Z"}), do: 3+6
	def winner(%{e: "C", m: "X"}), do: 1+6
	def winner(%{e: "C", m: "Y"}), do: 2+0
	def winner(%{e: "C", m: "Z"}), do: 3+3

	def part2(input) do
		input
		|> Enum.map(fn x -> splitter(x) end)
		|> Enum.map(fn x -> winai(x) end)
		|> Enum.sum
	end

	#new rules
	#X -> L
	#Y -> D
	#Z -> W
	def winai(%{e: "A", m: "X"}), do: 3+0
	def winai(%{e: "A", m: "Y"}), do: 1+3
	def winai(%{e: "A", m: "Z"}), do: 2+6
	def winai(%{e: "B", m: "X"}), do: 1+0
	def winai(%{e: "B", m: "Y"}), do: 2+3
	def winai(%{e: "B", m: "Z"}), do: 3+6
	def winai(%{e: "C", m: "X"}), do: 2+0
	def winai(%{e: "C", m: "Y"}), do: 3+3
	def winai(%{e: "C", m: "Z"}), do: 1+6

	def splitter(input) do
		input
		|> String.split(" ")
		|> Kernel.then(fn [x,y] -> %{e: x, m: y} end)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) |> String.split("\n")

		D02.part1(input) |> IO.puts
		D02.part2(input) |> IO.puts
	end
end

#A X 1 -> ROCK
#B Y 2 -> PAPER
#C Z 3 -> SCISSORS
#L -> 0
#E -> 3
#W -> 6