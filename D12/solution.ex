defmodule Point do
	defstruct [:height, :tag, :cost]
end

defmodule D12 do
	def part1(input) do
 		neighbours = [{0,1}, {0,-1}, {1,0}, {-1,0}]
   		{start_coords, start_point} = input |> Map.to_list()
	 	|> Enum.filter(fn {_, point} -> point.tag == "S" end)
   		|> hd
   		stack = [{start_coords, %{start_point | cost: 0}}]
	 	input = %{input | start_coords => %{start_point | cost: 0}}
		process_stack(stack, input, neighbours)
  		|> IO.inspect
  		|> then(fn {_, point} -> point.cost end)
	end

 	def process_stack([], _, _) do
		{{0,0}, %Point{height: 0, tag: "Error", cost: 41*144*2}}
  	end

 	def process_stack([head={_,point}|stack], map, neighbours) do
  		if point.tag != "E" do
			{map, new_stack} = process_neighbours(head, map, stack, neighbours)
   			process_stack(new_stack, map, neighbours)
		else
  			head
	 	end
  	end

   	def process_neighbours({coords, point}, map, stack, neighbours) do
		neighbours
  		|> Enum.map(&(absolute_neighbours(coords, &1)))
  		|> Enum.reduce({map,stack}, fn x,acc -> add_neighbour(acc, point.height, point.cost, x, map |> Map.get(x)) end)
 	end

  	def add_neighbour(acc, _, _, _, nil) do
		acc
   	end

  	def add_neighbour(acc={map,stack}, height, value, coords, point) do
		case {point.height, point.cost} do
			{_, v} when v <= value -> acc
   			{h, _} when h != height and h != height+1 and h > height -> acc
		  	_ -> {%{map | coords => %Point{height: point.height, tag: point.tag, cost: value+1}}, add_to_stack_secure(stack, {coords, %Point{height: point.height, tag: point.tag, cost: value+1}})}
  		end
   	end

  	def absolute_neighbours({x, y}, {delta_x, delta_y}) do
		{x+delta_x, y+delta_y}
  	end

   	def add_to_stack([], insert) do
		[insert]
 	end

   	def add_to_stack([head={_, head_point}|tail], insert={_,insert_point}) do
		if head_point.cost > insert_point.cost do
			[insert,head|tail]
  		else
			[head|add_to_stack(tail,insert)]
 		end
 	end

  	def add_to_stack_secure(stack, insert={coords,_}) do
		add_to_stack(stack |> Enum.reject(fn {c,_} -> c == coords end), insert)
   	end

	def part2(input) do
		neighbours = [{0,1}, {0,-1}, {1,0}, {-1,0}]
   		input |> Map.to_list()
	 	|> Enum.filter(fn {_, point} -> point.tag == "S" || point.tag == "a" end)
   		|> Enum.map(fn x -> prepare_starting_point(input, x, neighbours) end)
	 	|> Enum.min
	end

 	def prepare_starting_point(input, {start_coords, start_point}, neighbours) do
		stack = [{start_coords, %{start_point | cost: 0}}]
	 	input = %{input | start_coords => %{start_point | cost: 0}}
		process_stack(stack, input, neighbours)
  		|> then(fn {_, point} -> point.cost end)
  	end

 	def value_parse(value, translator) do
		%Point{height: translator[:binary.first(value)], tag: value, cost: 41*144*2}
	end

 	def static_letter_map() do
		Map.new(
  			[[?S], ?a..?z, [?E]] 
	  		|> Enum.flat_map(&(&1))
			|> Enum.zip([[1],1..26,[26]] |> Enum.flat_map(&(&1))))
  	end
end

defmodule Main do
	def execute(day) do
  		static_mapper = D12.static_letter_map()
		input = Input.file(day)
		|> String.split("\n")
  		|> Enum.map(fn x -> String.graphemes(x) |> Enum.map(&(D12.value_parse(&1, static_mapper))) end)
		|> Maping.create_map
		
		D12.part1(input) |> IO.puts
		D12.part2(input) |> IO.puts
	end
end