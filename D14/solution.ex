defmodule D14 do
	def part1(input) do
 		edges = input
   		|> find_edges
	 	|> IO.inspect
		Stream.iterate(0, &(&1+1))
  		|> Enum.reduce({input, 0}, fn x,acc -> drop_block end)
	end

 	def drop_block({map, i}, edges) do
		
  	end

	def part2(input) do
		input
	end

 	def parse_line(line) do
		line
  		|> String.split(" -> ")
		|> Enum.map(&point_parse_from_string/1)
  	end

   	def point_parse_from_string(p) do
		p
  		|> String.split(",")
		|> then(fn [x,y] -> {x |> String.to_integer, y |> String.to_integer} end)
  	end

   	def draw_line(map, [_]) do
		map
 	end

   	def draw_line(map, [{x1,y1},p2={x2,y2}|line_points]) do
		Enum.zip(stream_range(x1,x2), stream_range(y1,y2))
  		|> Enum.reduce(map, fn p,acc -> acc |> MapSet.put(p) end)
		|> draw_line([p2|line_points])
 	end

  	def stream_range(p1, p2) do
		cond do
			p1 == p2 -> Stream.iterate(p1, &(&1))
   			true -> Enum.min_max([p1,p2]) |> then(fn {x,y} -> x..y end)
		end
   	end

 	def find_edges(map) do
		{
  			map
	  		|> MapSet.to_list
			|> Enum.map(fn {x,_} -> x end)
	  		|> Enum.min_max,
 			map
	  		|> MapSet.to_list
			|> Enum.map(fn {_,y} -> y end)
	  		|> Enum.max
	 	}
  	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n", trim: true)
		|> Enum.map(&D14.parse_line/1)
  		|> Enum.reduce(MapSet.new(), fn x,acc -> D14.draw_line(acc, x) end)
		|> IO.inspect

		D14.part1(input) #|> IO.puts
		#D14.part2(input) |> IO.puts
	end
end