defmodule D20 do
	def part1(input) do
  		count = input |> Enum.count
		input = input
  		|> Enum.with_index(0)
  		updated_crypt = crypter(input, input, count)
		|> Enum.map(fn {x,_} -> x end)
		zero_index = updated_crypt |> Enum.find_index(fn x -> x == 0 end)
		[1_000, 2_000, 3_000]
  		|> Enum.map(&(&1+zero_index))
  		|> Enum.map(fn x -> Enum.at(updated_crypt, rem(x, count)) end)
		|> Enum.sum
	end

 	def process_next_index(crypto, element={value,_}, count) do
  		index = crypto |> Enum.find_index(fn x -> x == element end)
		{head, [_|tail]} = crypto |> Enum.split(index)
		head++tail
  		|> Enum.split(Integer.mod((index + value), count - 1))
		|> then(fn {x,y} -> x ++ [element | y] end)
  	end

	def part2(input) do
 		input = input
   		|> Enum.map(&(&1 * 811_589_153))
   		|> Enum.with_index(0)
  		count = input |> Enum.count
 		updated_crypt = 1..10
   		|> Enum.reduce(input, fn _,acc -> crypter(input, acc, count) end)
	 	|> Enum.map(fn {x,_} -> x end)
		zero_index = updated_crypt |> Enum.find_index(fn x -> x == 0 end)
		[1_000, 2_000, 3_000]
  		|> Enum.map(&(&1+zero_index))
  		|> Enum.map(fn x -> Enum.at(updated_crypt, rem(x, count)) end)
		|> Enum.sum
	end

 	def crypter(crypt, message, count) do
  		crypt
		|> Enum.reduce(message, fn e,acc -> process_next_index(acc, e, count) end)
  	end

 	def custom_rem(number, diviser) do
		number
  		|> rem(diviser)
		|> Kernel.+(diviser)
  		|> rem(diviser)
  	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")
		|> Enum.map(&String.to_integer/1)

		D20.part1(input) |> IO.puts
		D20.part2(input) |> IO.puts
	end
end