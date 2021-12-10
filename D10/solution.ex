
defmodule Part1 do
	def solution(input) do
		input
		|> Enum.map(&process_line(&1, ["0"]))
		|> Enum.reject(fn {x,_} -> x == nil end)
		|> Enum.map(fn {x,_} -> x end)
		|> Enum.map(&symbol_cost/1)
		|> Enum.sum
		|> IO.inspect
	end

	def process_line([], accumulator) do
		{nil, accumulator}
	end

	def process_line([head|tail], [acchead|acctail] = accumulator) do
		case is_enclosing(head) do
			true -> process_line(tail, [head|accumulator])
			_ -> case can_close(head, acchead) do
				true -> process_line(tail, acctail)
				_ -> {head, nil}
			end
		end
	end

	def is_enclosing(symbol) do
		["(", "[", "{", "<"] |> Enum.any?(&(&1 == symbol))
	end

	def can_close(symbol, stack) do
		#{%{"]" => "[", "}" => "{", ">" => "<", ")" => "("}[symbol] == stack, symbol, stack} |> IO.inspect
		%{"]" => "[", "}" => "{", ">" => "<", ")" => "("}[symbol] == stack
	end

	def symbol_cost(symbol) do
		%{"]" => 57, "}" => 1197, ">" => 25137, ")" => 3}[symbol]
	end
end

defmodule Part2 do
	def solution(input) do
		input
		|> Enum.map(&Part1.process_line(&1, ["0"]))
		|> Enum.reject(fn {_, x} -> x == nil end)
		|> Enum.map(fn {_, x} -> x end)
		|> Enum.map(&dive_remaining(0, &1))
		|> Enum.sort
		|> then(
			fn x -> Enum.at(x, (length(x)-1)/2 |> trunc) end
		)
		|> IO.inspect
	end

	def dive_remaining(accumulator, ["0"]) do
		accumulator
	end

	def dive_remaining(accumulator, [head|tail]) do
		(accumulator * 5 + symbol_cost(head))
		|> dive_remaining(tail)
	end

	def symbol_cost(symbol) do
		%{"(" => 1, "[" => 2, "{" => 3, "<" => 4}[symbol]
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n", trim: true)
		|> Enum.map(fn x -> String.split(x, "", trim: true) end)

		input
		|> Part1.solution
		
		input
		|> Part2.solution
	end
end