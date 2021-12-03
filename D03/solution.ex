defmodule Part1 do
	def process_input([]) do
		[]
	end
	def process_input([head|input]) do
		[process_input(head)] ++ process_input(input)
	end
	def process_input(input_line) do
		input_line 
			|> String.split("", trim: true)
			|> Enum.map(fn n -> get_int(n)*2-1 end)
	end
	def get_int(num) do
		{parsed, _} = Integer.parse(num)
		parsed
	end
	def add_lists(total, []) do
		total
	end
	def add_lists(total, [head|tail]) do
		Enum.zip(head, total) 
		|> Enum.map(fn {x,y} -> x+y end)
		|> add_lists(tail)
	end
	def get_binary([], total, _, _) do
		total
	end
	def get_binary([head|tail], total, reverse, step) do
		case head do
			n when n*reverse > 0 -> get_binary(tail, total+step, reverse, step*2)
			_ -> get_binary(tail, total, reverse, step*2)
		end
	end
end

defmodule Part2 do
	def find_highest_occurance([element], _, _) do
		element
	end
	def find_highest_occurance(elements, current, reverse) do
		[ehead|etail] = elements
		esolution = Part1.add_lists(ehead, etail)
		case Enum.at(esolution, current) do
			n when n*reverse > 0 -> elements 
				|> Enum.filter(fn x -> Enum.at(x, current) > 0 end)
			n when n*reverse < 0 -> elements 
				|> Enum.filter(fn x -> Enum.at(x, current) < 0 end)
			_ -> elements 
				|> Enum.filter(fn x -> Enum.at(x, current)*reverse > 0 end)
		end 
			|> find_highest_occurance(current+1, reverse)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
			|> Input.split("\n")

		input1 = Part1.process_input(input)
		[head1|tail1] = input1
		tsolution1 = Part1.add_lists(head1, tail1)
		solution1 = tsolution1 
			|> Enum.reverse() 
			|> Part1.get_binary(0,1,1)

		solution1 = tsolution1 
			|> Enum.reverse() 
			|> Part1.get_binary(0,-1,1) 
			|> Kernel.*(solution1)
		IO.puts solution1

		solution2 = input1 
			|> Part2.find_highest_occurance(0,1) 
			|> Enum.reverse 
			|> Part1.get_binary(0,1,1)

		solution2 = input1 
			|> Part2.find_highest_occurance(0,-1) 
			|> Enum.reverse 
			|> Part1.get_binary(0,1,1) 
			|> Kernel.*(solution2)
			
		solution2 |> IO.puts
	end
end