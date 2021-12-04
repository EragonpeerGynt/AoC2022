defmodule Part1 do
	def get_solution(input) do
		input
			|> parse_input
			|> process_cards
			|> card_value
	end

	def process_cards({numbers, cards}) do
		find_winning_card(numbers, [], cards, nil)
	end

	def card_value({{_card, card_nums}, last_called, called_nums}) do
		(card_nums -- called_nums)
			|> Enum.map(fn x -> String.to_integer(x) end)
			|> Enum.sum
			|> card_multi(last_called)
	end

	def card_multi(sum, last_called) do 
		String.to_integer(last_called) |> Kernel.*(sum)
	end

	def find_winning_card([head | tail], called_nums, cards, nil) do
		new_called_nums = [head | called_nums]

		cards
			|> Enum.find(&(is_winning_card?(new_called_nums, &1)))
			|> case do
				nil -> find_winning_card(tail, new_called_nums, cards, nil)
				winning -> find_winning_card(tail, new_called_nums, cards, {winning, head, new_called_nums})	
		end
	end

	def find_winning_card(_nums, _called_nums, _cards, card_and_num) do
		card_and_num
	end

	def is_winning_card?(called_nums, {combinations, _nums}) do
		Enum.any?(combinations, &(length(&1 -- called_nums) == 0))
	end

	def parse_input(input) do
		{[nums], cards} =
			input
				|> String.split("\n\n")
				|> Enum.split(1)

		parsed_nums =
			nums
				|> String.split(",", trim: true)

		parsed_cards =
			cards
				|> Enum.map(&parse_card/1)

		{parsed_nums, parsed_cards}
	end

  	def parse_card(card_input) do
		rows =
			card_input
				|> String.split("\n", trim: true)
				|> Enum.map(&String.split/1)

		columns =
			rows
				|> Enum.zip()
				|> Enum.map(&Tuple.to_list/1)

		{Enum.concat(rows, columns), List.flatten(rows)}
  	end
end

defmodule Part2 do
	def get_solution(input) do
		input
			|> Part1.parse_input
			|> process_cards
			|> Part1.card_value
  	end

	def process_cards({numbers, cards}) do
		find_last_winning_card(numbers, [], cards)
	end

	def find_last_winning_card(nums, called_nums, [card] = cards) do
		Part1.find_winning_card(nums, called_nums, cards, nil)
	end

	def find_last_winning_card([head | tail], called_nums, cards) do
		new_called_nums = [head | called_nums]

		new_cards = cards
			|> Enum.reject(&(Part1.is_winning_card?(new_called_nums, &1)))
		
		find_last_winning_card(tail, new_called_nums, new_cards)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		Part1.get_solution(input) |> IO.puts
		Part2.get_solution(input) |> IO.puts
	end
end