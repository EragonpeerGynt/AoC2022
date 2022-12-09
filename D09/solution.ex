defmodule D09 do
	def part1(input) do
 		head = {0,0}
   		tail = [{0,0}]
	 	moves = %{"R"=> {1,0}, "L"=> {-1,0}, "U"=> {0,1}, "D"=> {0,-1}}
	 	observed = MapSet.new([{0,0}])
		input
  		|> Enum.reduce({head, tail, observed}, fn x, acc -> prepare_head(acc,moves[x]) end)
		|> then(fn {_, _, x} -> x end)
  		|> Enum.count
	end

   	def points_nerby({head_x, head_y}, {tail_x, tail_y}) do
		(abs(head_x - tail_x) <= 1) && (abs(head_y - tail_y) <= 1)
 	end

  	def trace_tail({head_x, head_y}, {tail_x, tail_y}) do
		{find_required_tail_delta(head_x, tail_x), find_required_tail_delta(head_y, tail_y)}
   	end

 	def find_required_tail_delta(head_point, tail_point) do
		case head_point - tail_point do
			delta when delta > 0 -> tail_point + 1
			delta when delta < 0 -> tail_point - 1
   			_ -> tail_point
  		end
  	end

	def part2(input) do
 		head = {0,0}
   		tail = Main.replicate(9, {0,0})
	 	moves = %{"R"=> {1,0}, "L"=> {-1,0}, "U"=> {0,1}, "D"=> {0,-1}}
	 	observed = MapSet.new([{0,0}])
   		
		input
  		|> Enum.reduce({head, tail, observed}, fn x, acc -> prepare_head(acc,moves[x]) end)
		|> then(fn {_, _, x} -> x end)
  		|> Enum.count
 	end

 	def prepare_head({{head_x, head_y}, tail, observed}, {delta_x, delta_y}) do
		new_head = {head_x + delta_x, head_y + delta_y}
  		tail
		|> Enum.reduce({new_head, []}, fn t,acc -> tail_diver(acc, t) end)
  		|> then(fn {last_tail, processed} -> {new_head, processed |> Enum.reverse, observed |> MapSet.put(last_tail)} end)
  	end

   	def tail_diver({head, processed}, tail) do
		if (points_nerby(head, tail)) do
			{tail, [tail|processed]}
  		else
			trace_tail(head, tail)
   			|> then(fn new_tail -> {new_tail, [new_tail|processed]} end)
 		end
 	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")
		|> Enum.map(fn x -> x |> String.split(" ") |> then(fn [d,c] -> replicate(c |> String.to_integer, d) end) end)
  		|> Enum.flat_map(&(&1))

		D09.part1(input) |> IO.puts
		D09.part2(input) |> IO.puts
	end

 	def replicate(n, x), do: for i <- 0..n, i > 0, do: x
end