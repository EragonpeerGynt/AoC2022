defmodule D13 do
	def part1(input) do
		input
		|> Enum.chunk_every(2)
  		|> Enum.map(&list_ordered/1)
		|> Enum.with_index(1)
  		|> Enum.filter(fn {x,_} -> x end)
		|> Enum.map(fn {_,y} -> y end)
		|> Enum.sum
	end

 	def list_ordered([x, y]), do: list_ordered({x, y})

   	def list_ordered({x, y}) do
		Enum.zip(x,y)
  		|> Enum.map(&anonymous_pair/1)
		|> Enum.find(fn x -> x != nil end)
  		|> eval_list_finds(x,y)
  	end

   	def eval_list_finds(matches, x, y) do
		case matches do
	  		nil -> compare_element({x |> Enum.count, y |> Enum.count})
	 		x -> x
  		end
 	end

   	def compare_element({x,y}) do
		cond do
			x > y -> false
   			x < y -> true
	  		true -> nil
  		end
 	end

   	def anonymous_pair(p={x, y}) do
		cond do
			is_list(x) and is_list(y) -> list_ordered(p)
   			is_list(x) and is_integer(y) -> list_ordered({x,[y]})
	  		is_integer(x) and is_list(y) -> list_ordered({[x],y})
	 		is_integer(x) and is_integer(y) -> compare_element(p)
			true -> nil
  		end
 	end

	def part2(input) do
 		{m1,m2} = {[[2]], [[6]]}
		[m1,m2|input]
  		|> Enum.sort(fn x,y -> list_ordered({x,y}) end)
		|> Enum.with_index(1)
  		|> find_markers([m1,m2])
  		|> Enum.product
  		
	end

 	def find_markers(signal, markers) do
		markers
  		|> Enum.map(fn x -> signal |> Enum.find(fn {y,_} -> y == x end) end)
		|> Enum.map(fn {_,y} -> y end)
  	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n", trim: true)
		|> Enum.map(&(Code.eval_string(&1) |> then(fn {x,_} -> x end)))
  		
		D13.part1(input) |> IO.puts
		D13.part2(input) |> IO.puts
	end
end