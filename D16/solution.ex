defmodule Part1 do
	def solution(input) do
		input 
		|> Main.process_version
		|> then(fn {version, operation, commands, _} -> dive_parts({version, operation, commands}) end)
		|> IO.inspect
	end
	
	def dive_parts({n, 4, _}) do
		n
	end

	def dive_parts({n, _, commands}) do
		n + (commands |> Enum.map(&dive_parts/1) |> Enum.sum)
	end
end

defmodule Part2 do
	def solution(input) do
		input 
		|> Main.process_version
		|> then(fn {version, operation, commands, _} -> dive_parts({version, operation, commands}) end)
		|> IO.inspect
	end

	def dive_parts({_, 4, value}) do
		value
	end

	def dive_parts({_, 0, commands}) do
		commands |> Enum.map(&dive_parts/1) |> Enum.sum
	end

	def dive_parts({_, 1, commands}) do
		commands |> Enum.map(&dive_parts/1) |> Enum.product
	end

	def dive_parts({_, 2, commands}) do
		commands |> Enum.map(&dive_parts/1) |> Enum.min
	end

	def dive_parts({_, 3, commands}) do
		commands |> Enum.map(&dive_parts/1) |> Enum.max
	end

	def dive_parts({_, 5, commands}) do
		commands 
		|> Enum.map(&dive_parts/1) 
		|> then(fn [x,y] -> if x > y, do: 1, else: 0 end)
	end

	def dive_parts({_, 6, commands}) do
		commands 
		|> Enum.map(&dive_parts/1)
		|> then(fn [x,y] -> if x < y, do: 1, else: 0 end)
	end

	def dive_parts({_, 7, commands}) do
		commands 
		|> Enum.map(&dive_parts/1)
		|> then(fn [x,y] -> if x == y, do: 1, else: 0 end)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("", trim: true)
		|> Enum.map(&hex_to_dec_char/1)
		|> Enum.flat_map(&(String.split(&1, "", trim: true)))
		|> Enum.map(&String.to_integer/1)

		#input
		#|> Part1.solution

		input
		|> Part2.solution
	end

	def hex_to_dec_char(char) do
		mapping = %{
			"0" => "0000",
			"1" => "0001",
			"2" => "0010",
			"3" => "0011",
			"4" => "0100",
			"5" => "0101",
			"6" => "0110",
			"7" => "0111",
			"8" => "1000",
			"9" => "1001",
			"A" => "1010",
			"B" => "1011",
			"C" => "1100",
			"D" => "1101",
			"E" => "1110",
			"F" => "1111"
		}
		mapping[char]
	end

	def dec_to_int(decimal) do
		decimal
		|> Enum.drop_while(fn x -> x == 0 end)
		|> Enum.reverse
		|> dec_to_int(1)
	end

	def dec_to_int([], _) do
		0
	end

	def dec_to_int([head|tail], step) do
		(head*step)+dec_to_int(tail, step*2)
	end

	def process_version(stack) do
		get_version(stack)
		|> process_operation
	end

	def process_version(stack, number) do
		1..number
		|> Enum.reduce({[],stack}, fn _,{acc,remaining} -> 
			process_version(remaining) 
			|> then(fn {version, operation, node, inner_stack} ->
				{[{version, operation, node}|acc], inner_stack}
				end)
			end)
		|> then(fn {commands,remaining} -> {commands |> Enum.reverse, remaining} end)
	end

	def process_operation({version, stack}) do
		get_operation(stack)
		|> then(fn {operation, remaining} -> process_operation({version, operation, remaining}) end)
	end

	def process_operation({version, 4 = operation, stack}) do
		get_literar_value(stack)
		|> then(fn {literal, remaining} -> {version, operation, literal|> dec_to_int, remaining} end)
	end

	def process_operation({version, operation, [0|stack]}) do
		Enum.take(stack, 15) 
		|> dec_to_int
		|> then(fn length -> 
			stack 
			|> Enum.drop(15) 
			|> Enum.take(length) 
			|> process_n_bits 
			|> then(fn x -> 
				{
					version,
					operation,
					x,
					stack 
					|> Enum.drop(15)
					|> Enum.drop(length)
				} 
				end)
			end)
	end

	def process_operation({version, operation, [1|stack]}) do
		Enum.take(stack, 11) 
		|> dec_to_int
		|> then(fn length -> 
			stack
			|> Enum.drop(11)
			|> process_version(length)
			|> then(fn {commands, remaining} -> 
				{version, operation, commands, remaining} 
				end)
			end)
	end

	def process_n_bits([]) do
		[]
	end

	def process_n_bits(stack) do
		process_version(stack)
		|> then(fn {version, operation, command ,remaining} -> 
			[{version,operation,command}|process_n_bits(remaining)] 
			end)
	end

	def get_operation(stack) do
		get_next_3_bits(stack)
	end

	def get_version(stack) do
		get_next_3_bits(stack)
	end

	def get_next_3_bits([h1,h2,h3|tail]) do
		{dec_to_int([h1,h2,h3]), tail}
	end

	def get_literar_value([0,h1,h2,h3,h4|tail])	do
		{[h1,h2,h3,h4], tail}
	end

	def get_literar_value([1,h1,h2,h3,h4|tail])	do
		get_literar_value(tail)
		|> then(fn {x,y} -> {[h1,h2,h3,h4|x], y} end)
	end
end