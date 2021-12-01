defmodule D01 do
	def part1(_, [], total) do
		total
	end
	def part1(previous, [head|tail], total) do
		case (head - previous) do
			n when n > 0 -> D01.part1(head, tail, total+1)
			_ -> D01.part1(head, tail, total)
		end
	end
	def part2(_, [_], total) do
		total
	end
	def part2(previoussum, [head|tail], total) do
		currentsum = tail |> Enum.take(2) |> Enum.sum()
		currentsum = currentsum + head
		case (currentsum - previoussum) do
			n when n > 0 -> D01.part2(currentsum, tail, total+1)
			_ -> D01.part2(currentsum, tail, total)
		end
	end
end

[day|_] = System.argv
input = Input.file(day) 
	|> Input.split("\n")
	|> Enum.map(fn x -> Integer.parse(x) end) 
	|> Enum.map(fn {x,_} -> x end)

[head|tail] = input

D01.part1(head, tail, 0) |> IO.puts

firstsum = input |> Enum.take(3) |> Enum.sum()
D01.part2(firstsum, tail, 0) |> IO.puts

