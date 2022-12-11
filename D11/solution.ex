defmodule D11 do
	def part1(input) do
		1..20
  		|> Enum.reduce(input, fn _,acc -> process_round(acc, fn worry -> div(worry, 3) end) end)
		|> Enum.map(fn {_,{_, _, _, _, processed}} -> processed end)
  		|> Enum.sort(:desc)
		|> then(fn [x,y|_] -> x * y end)
	end

	def process_round(input, relief) do
		0..7
  		|> Enum.reduce(input, fn i,acc -> monkey_brains(i, acc, acc |> Map.get(i), relief) end)
	end

 	def monkey_brains(index, monkeys, {items, transform, check, anwser, processed}, relief) do
  		item_count = items |> Enum.count
		items
  		|> Enum.reduce({monkeys}, fn item,acc -> process_item(acc, relief.(transform.(item)), check, anwser) end)
		|> then(fn {x} -> %{x | index => {[], transform, check, anwser, processed + item_count}} end)
	end

 	def process_item({monkeys}, worry, check, {if_true, if_false}) do
		index = if (rem(worry, check) == 0) do
			if_true
  		else
			if_false
 		end
   		{%{monkeys | index => add_item_to_monkey(monkeys |> Map.get(index), worry)}}
  	end

   	def add_item_to_monkey({items, transform, check, anwser, processed}, item) do
		{items |> Enum.reverse |> then(fn x -> [item|x] end) |> Enum.reverse, transform, check, anwser, processed}
 	end

   	def hardcoded_input() do
		%{
  			0 => {[92, 73, 86, 83, 65, 51, 55, 93], fn x -> x * 5 end, 11, {3, 4},0},
	 		1 => {[99, 67, 62, 61, 59, 98], fn x -> x * x end, 2, {6, 7},0},
			2 => {[81, 89, 56, 61, 99], fn x -> x * 7 end, 5, {1, 5},0},
   			3 => {[97, 74, 68], fn x -> x + 1 end, 17, {2, 5},0},
	  		4 => {[78, 73], fn x -> x + 3 end, 19, {2, 3},0},
	 		5 => {[50], fn x -> x + 5 end, 7, {1, 6},0},
			6 => {[95, 88, 53, 75], fn x -> x + 8 end, 3, {0, 7},0},
   			7 => {[50, 77, 98, 85, 94, 56, 89], fn x -> x + 2 end, 13, {4, 0},0}
		}
 	end

  	def part2(input) do
   		common_index = input |> get_common
		1..10000
  		|> Enum.reduce(input, fn _,acc -> process_round(acc, fn worry -> rem(worry, common_index) end) end)
		|> Enum.map(fn {_,{_, _, _, _, processed}} -> processed end)
  		|> Enum.sort(:desc)
		|> then(fn [x,y|_] -> x * y end)
	end

 	def get_common(input) do
		input
  		|> Enum.map(fn {_,{_, _, div, _, _}} -> div end)
		|> Enum.product
  	end
end

defmodule Main do
	def execute(_day) do
		input = D11.hardcoded_input()

		D11.part1(input) |> IO.puts
		D11.part2(input) |> IO.puts
	end
end