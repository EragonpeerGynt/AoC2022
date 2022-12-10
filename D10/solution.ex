defmodule D10 do
	def part1(input) do
 		checks = (0..5) |> Enum.map(fn x -> x*40+20 end) |> IO.inspect
		input
  		|> Enum.reduce({1,1,checks,[]}, fn x,acc -> process_command(x, acc) end)
		|> then(fn {_, _, _, checksum} -> checksum end)
  		|> Enum.sum
	end

	def process_command(command, {register, cycle, checks, checksum}) do
 		{checks, checksum} = cycle_jump(register, cycle, checks, checksum)
		case command do
			<<"addx ", increase::binary>> -> increase |> String.to_integer |> then(fn x -> {register+x, cycle+2, checks, checksum} end)
   			<<"noop">> -> {register, cycle+1, checks, checksum}
  		end
 	end

  	def cycle_jump(_, _, checks = [], checksum) do
		{checks, checksum}
  	end

  	def cycle_jump(register, cycle, checks = [next_check|remaining_checks], checksum) do
		if (cycle == next_check || cycle + 1 == next_check) do
			{remaining_checks, [next_check * register|checksum]}
  		else
			{checks, checksum}
 		end
   	end
 
	def part2(input) do
 		cycles = 1..6 |> Enum.map(fn _ -> 1..40 end) |> Enum.flat_map(&(&1))
   		nearby = 0..2
		input
  		|> Enum.map(fn x -> 
			case x do
   				<<"addx ", _::binary>> -> ["noop",x]
	   			_ -> [x]
	   		end
	  	end)
		|> Enum.flat_map(&(&1))
  		|> Enum.zip(cycles)
		|> Enum.reduce({1,[]}, fn x,acc -> process_advance_commands(x, acc, nearby) end)
  		|> then(fn {_, x} -> x |> Enum.reverse end)
		|> Enum.chunk_every(40)
  		|> Enum.map(&(&1 |> Enum.join("")))
		|> then(&(&1 |> Enum.join("\n")))
	end

 	def process_advance_commands({command, cycle}, {register, display}, nearby) do
		display = display_pixel(cycle, register, display, nearby)
  		case command do
			<<"addx ", increase::binary>> -> increase |> String.to_integer |> then(fn x -> {register+x, display} end)
   			<<"noop">> -> {register, display}
  		end
  	end

   	def display_pixel(cycle, register, display, nearby) do
		if (nearby |> Enum.any?(fn x -> register + x == cycle end)) do
			["#"|display]
  		else
			["."|display]
 		end
 	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")

		#D10.part1(input) |> IO.puts
		D10.part2(input) |> IO.puts
	end
end