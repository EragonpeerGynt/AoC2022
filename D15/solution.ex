defmodule CRange do
	defstruct [:start, :last]
 	def get_range(x,y) do
		%CRange{start: x, last: y}
  	end

	def in_range(%CRange{start: x, last: y}, i) do
		(x <= i && y >= i)
 	end

  	def size(%CRange{start: x, last: y}) do
		(y-x+1)
   	end
end

defmodule D15 do
	def part1(input) do 		
		possible_matches = input
  		|> Enum.reduce([], fn x,acc -> draw_nth_line(2_000_000, x, find_distance(x), acc) end)
  		|> list_union

  		targeted_beacons = input
  		|> Enum.map(fn {_,x} -> x end)
		|> Enum.filter(fn {_,y} -> y == 2_000_000 end)
  		|> Enum.map(fn {x,_} -> x end)
		|> Enum.uniq
		|> Enum.count

  		(possible_matches
		|> Enum.map(&CRange.size/1)
  		|> Enum.sum) - targeted_beacons
	end

	def draw_nth_line(n, {s, _}, distance, map) do
 		case(reaches_searchline(n, s, distance)) do
			{true, d} -> add_range(s, d, map)
   			{false, _} -> map
   		end
 	end

  	def add_range({x,_}, distance_remaining, map) do
		[CRange.get_range((-distance_remaining+x), (distance_remaining+x))|map]
   	end

  	def reaches_searchline(n, {_,y}, distance) do
		case abs(n - y) do
			d when d <= distance -> {true, abs(distance - d)}
   			_ -> {false, nil}
  		end
   	end

 	def find_distance({x, y}) do
		find_distance(x,y)
 	end

	def find_distance({x1, y1}, {x2, y2}) do
		abs(x1-x2)+abs(y1-y2)
 	end

  	def list_union(lists) do
		lists
  		|> Enum.sort_by(fn x -> x.start end, :asc)
		|> Enum.reduce([], fn x, acc -> get_union(acc, x) end)
   	end

 	def get_union(processed, new_range) do
		case List.last(processed) do
			nil -> [new_range]
   			last_range when last_range.last >= new_range.start - 1 -> 
				processed |> List.replace_at(-1, CRange.get_range(last_range.start, max(last_range.last, new_range.last)))
   			_ -> processed ++ [new_range]
  		end
  	end

 	def list_union_calculator(current_union, next_part) do
		case List.last(current_union) do
			nil -> [next_part]
   			current_part -> expand_range(current_union, current_part, next_part)
  		end
  	end

   	def expand_range(current_union, current_range, next_range) do
		if (get_last_range(current_range) >= get_first_range(next_range) - 1) do
			current_union |> List.replace_at(-1,  get_first_range(current_range)..max(get_last_range(current_range), get_last_range(next_range)))
   		else
			current_union ++ [next_range]
  		end
 	end

   	def get_first_range(first.._//_) do
		first
 	end

  	def get_last_range(_..last//_) do
		last
 	end
	
	def part2(input) do
 		tuning = 4_000_000
		0..tuning
  		|> Enum.reduce_while({}, fn x,acc -> find_multipart_row(x, acc, input) end)	
		|> then(fn {x,y} -> x * tuning + y end)
	end

  	def find_multipart_row(row, acc, map) do
		parts = map
  		|> Enum.reduce([], fn x,acc -> draw_nth_line(row, x, find_distance(x), acc) end)
  		|> list_union

  		case parts |> Enum.count do
			x when x <= 1 -> {:cont, acc}
   			_ -> {:halt, {(parts |> Enum.at(0)).last+1, row}}
 		end
   	end
end

defmodule Main do
	def execute(day) do
		input = 
  		Regex.replace(~r/[a-zA-Z= ]/, Input.file(day), "")
		|> String.split("\n")
  		|> Enum.map(fn line -> String.split(line, [",",":"]) |> Enum.map(&String.to_integer/1) |> then(fn [s_x, s_y, b_x, b_y] -> {{s_x, s_y}, {b_x, b_y}} end) end)

		D15.part1(input) |> IO.puts
		D15.part2(input) |> IO.puts
	end
end