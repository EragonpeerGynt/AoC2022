defmodule D21 do
	def part1(input) do
		get_value("root", input)
	end

 	def get_value(node, map) do
		case map |> Map.get(node) do
			value when is_number(value) -> value
   			value -> value.(map, &get_value/2)
  		end
  	end

	def part2(input, [name, first, _, last]) do
 		input = %{input | name => fn m,getter -> getter.(first, m) == getter.(last, m) end}
		1..1_000_000_000
  		|> Enum.reduce_while(0, fn x,_ -> if(!new_human(input,x), do: {:cont, 0}, else: {:halt, x}) end)
	end

 	def new_human(input, value) do
  		get_value("root", %{input | "humn" => value})
	end

 	def parse_line(map, [name, first, operator, last]) do
		map
  		|> Map.put(name,
			case operator do
				"+" -> fn m,getter -> getter.(first, m) + getter.(last, m) end
	   			"-" -> fn m,getter -> getter.(first, m) - getter.(last, m) end
				"*" -> fn m,getter -> getter.(first, m) * getter.(last, m) end
	   			"/" -> fn m,getter -> getter.(first, m) |> div(getter.(last, m)) end
	  		end)
  	end

   	def parse_line(map, [name, value]) do
		map
  		|> Map.put(name, String.to_integer(value))
 	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")
		|> Enum.map(&String.split(&1, [": ", " "]))
  		parsed_input = input
  		|> Enum.reduce(Map.new(), fn x,acc -> D21.parse_line(acc, x) end)

		#D21.part1(parsed_input) |> IO.puts
		D21.part2(parsed_input, input |> Enum.find(fn [x|_] -> x == "root" end)) |> IO.puts
	end
end