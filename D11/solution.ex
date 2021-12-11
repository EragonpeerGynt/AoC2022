defmodule Part1 do
	def solution(input) do
		flash_cycle(input, 0, 0)
		|> IO.inspect
	end

	def flash_cycle(_, 100, acc) do
		acc
	end

	def flash_cycle(map, iteration, acc) do
		cooldown_travel(map, map |> Map.to_list)
		|> then(fn x -> flash_cooldown(x |> Map.to_list |> Enum.reject(fn {_, y} -> y <= 9 end), x, acc) end)
		|> then(fn {acc_map, acc_acc} -> flash_cycle(acc_map, iteration+1, acc_acc) end)
	end

	def cooldown_travel(map, []) do
		map
	end

	def cooldown_travel(map, [head|tail]) do
		increase_power(head, map)
		|> cooldown_travel(tail)
	end 

	def flash_cooldown([], map, acc) do
		{map, acc}
	end

	def flash_cooldown([{coor, _}|tail], map, acc) do
		flash_cooldown(tail, %{map | coor => 0}, acc+1)
	end

	def increase_power({{x, y} = coor, _}, map) do
		if map[coor] == 9 do
			#{"-", map[coor]} |> IO.inspect
			map = %{map | coor => 10}
			#{"#", coor, map[coor]} |> IO.inspect
			for(
				dx <- (x - 1)..(x + 1),
				dy <- (y - 1)..(y + 1),
				{x, y} != {dx, dy},
				do: {dx, dy})
			|> Enum.map(fn coor -> {coor, map[coor]} end)
			|> Enum.reject(fn {_, value} -> value == nil end)
			|> Enum.reduce(map, fn {point, _}, acc_map -> increase_power({point, acc_map[point]}, acc_map) end)
		else
			%{map | coor => map[coor]+1}
		end
	end
end

defmodule Part2 do
	def solution(input) do
		flash_cycle(input, 1)
		|> IO.inspect
	end

	def flash_cycle(map, iteration) do
		Part1.cooldown_travel(map, map |> Map.to_list)
		|> then(fn x -> Part1.flash_cooldown(x |> Map.to_list |> Enum.reject(fn {_, y} -> y <= 9 end), x, 0) end)
		|> then(fn {acc_map, acc_acc} -> 
			case acc_acc do
				100 -> iteration
				_ -> flash_cycle(acc_map, iteration+1)
			end
		end)
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n", trim: true)
		|> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.map(&String.to_integer/1) end)
		|> Maping.create_map
		
		#input
		#|> Part1.solution
		
		input
		|> Part2.solution
	end
end