defmodule Part1 do
	def solution(map) do
		map
		|> solution(1, [], "start")
		|> IO.inspect
	end

	def solution(map, part, seen, cave) do
		#{map, seen, cave, map[cave]} |> IO.inspect
		case cave do
			"end" -> 1
			_ -> case continue_dive(part, seen, cave) do
				{true, new_part} -> map[cave] 
				|> Enum.map(fn x -> solution(map, new_part, [cave|seen], x) end)
				|> Enum.sum
				{false, _} -> 0
			end
		end
	end

	def continue_dive(part, seen, cave) do
		case seen |> Enum.any?(&(&1 == cave)) do
			true -> case is_upper?(cave) do
				true -> {true, part}
				false -> case cave do
					"start" -> {false, part}
					_ -> case part do
						1 -> {false, part}
						2 -> {true, 1}
					end
				end
			end
			false -> {true, part}
		end
	end

	def format_input([], map) do
		map
	end

	def format_input([head|input], map) do
		[from,to] = String.split(head, "-", trim: true)
		case map[from] do
			nil -> Map.put(map, from, [to])
			x -> %{map | from => [to | x]}
		end
		|> then(fn y -> case y[to] do
				nil -> Map.put(y, to, [from])
				x ->  %{y | to => [from | x]}
			end
		end)
		|> then(fn x -> format_input(input, x) end)
	end

	def is_upper?(string) do
		String.match?(string, ~r/^[A-Z]+$/)
	end
end

defmodule Part2 do
	def solution(map) do
		map
		|> Part1.solution(2, [], "start")
		|> IO.inspect
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n", trim: true)
		|> Part1.format_input(%{})
		|> IO.inspect
		
		input
		|> Part1.solution
		
		input
		|> Part2.solution
	end
end