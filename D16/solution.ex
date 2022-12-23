defmodule Valve do
	defstruct [:flow, :linked]

 	def set_valve(flow, linked) do
		%Valve{flow: flow, linked: linked}
   	end
end

defmodule Solution do
	def part1(input) do
		valves_left = input
  		|> Map.keys
		|> List.delete("AA")
  		|> IO.inspect
	end

 	def depth_search(_, _, _, _, total, 0) do
		total
  	end

   	def depth_search(_, _, [], flow, total, minute) do
		total + flow * minute
  	end

 	def depth_search(map, current, closed, flow, total, minute) do
		
  	end

	def part2(input) do
		input
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")
		|> Enum.reduce(%{}, fn x,acc -> parse_input_line(x, acc) end)

		Solution.part1(input) #|> IO.puts
		#Solution.part2(input) |> IO.puts
	end

 	def parse_input_line(row, store) do
		[name_and_flow, paths] = row |> String.split("; ")
  		[name] = ~r/(?<=Valve )[^ ]*/u |> Regex.run(name_and_flow)
		[flow] = ~r/(?<=rate=)[^ ]*/u |> Regex.run(name_and_flow)
  		linked = ~r/(?<=valves |valve ).*/u |> Regex.run(paths) |> then(fn [x] -> x |> String.split(", ") end)
  		store |> Map.put(name, Valve.set_valve(flow |> String.to_integer, linked))
  	end
end