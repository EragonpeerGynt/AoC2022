defmodule D25 do
	def part1(input) do
		input
  		|> Enum.map(&(translate_to_integer(&1, worth_map())))
  		|> Enum.map(&translate_base_to_decimal/1)
		|> Enum.sum
  		|> full_number_to_snafu()
	end

 	def translate_to_integer(snafu, map) do
		snafu
  		|> Enum.map(&(map[&1]))
  	end

   	def translate_base_to_decimal(number) do
		number
  		|> Enum.reduce(0, fn x,acc -> acc*5 + x end)
 	end

 	def convert_to_decimal_snafu(number, map) do
		number
  		|> Enum.reduce({[], false}, fn x,acc -> convert_bit(x,acc,map) end)
		|> then(fn {x,_} -> x end)
  	end

   	def convert_to_snafu(snafu, map) do
		snafu
		|> Enum.map(&(map[&1]))
 	end

   	def convert_bit(bit,{snafu,carry},map) do
		updated_bit = if carry do
  			bit+1
  		else
			bit
		end
		{[map[rem(updated_bit,5)]|snafu],updated_bit > 2}
 	end

	def part2(input) do
		input
	end

 	def snafu_decimal_map() do
		%{3 => -2, 4 => -1, 0 => 0, 1 => 1, 2 => 2}
  	end

 	def worth_map() do
		%{"=" => -2, "-" => -1, "0" => 0, "1" => 1, "2" => 2}
  	end

    def reverse_worth_map() do
		worth_map()
  		|> Map.to_list
		|> Map.new(fn {x,y} -> {y,x} end)
 	end

  	def full_number_to_snafu(number) do
		number
  		|> Integer.to_string(5)
		|> String.graphemes
  		|> then(fn x -> ["0"|x] end)
  		|> Enum.reverse
		|> Enum.map(&String.to_integer/1)
		|> convert_to_decimal_snafu(snafu_decimal_map())
		|> convert_to_snafu(reverse_worth_map())
  		|> remove_head_zero
  		|> Enum.join("")
   	end

 	def remove_head_zero(["0"|x]) do
  		x
  	end

   	def remove_head_zero(x) do
  		x
  	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")
		|> Enum.map(&String.graphemes/1)
  
		D25.part1(input) |> IO.puts
		#D25.part2(input) |> IO.puts
	end
end