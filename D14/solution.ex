defmodule Part1 do
	def solution({start, mappings}, max_depth \\ 10) do
		cycle_repeater(start, mappings, 0, max_depth)
		|> Enum.frequencies
		|> Map.to_list
		|> Enum.sort_by(fn {_,v} -> v end)
		|> Enum.map(fn {_,v} -> v end)
		|> then(fn x -> {
			x |> Enum.at(0), 
			x |> Enum.reverse |> Enum.at(0)} end)
		|> then(fn {l,h} -> h-l end)
		|> IO.inspect
	end

	def cycle_repeater(current_word, mappings, depth, max_depth) do
		case depth < max_depth do
			true -> current_word 
			|> process_cycle(mappings) 
			|> cycle_repeater(mappings, depth+1, max_depth)

			false -> current_word
		end
	end

	def process_cycle([fc,sc|tail], mappings) do
		[fc, mappings[{fc,sc}] | process_cycle([sc|tail], mappings)]
	end

	def process_cycle([_] = fc, _) do
		fc
	end

	def create_map(input) do
		input
		|> Enum.map(&String.split(&1, " -> ", trim: true))
		|> Enum.map(
			fn [c,v] -> {c 
			|> String.split("", trim: true)
			|> then(fn [f,s] -> {f,s} end), v} end)
		|> then(fn x -> create_map(%{}, x) end)
	end

	def create_map(map, []) do
		map
	end

	def create_map(map, [{c, v}|input]) do
		map |> Map.put(c, v) |> create_map(input)
	end
end

defmodule Part2 do
	def solution({start, mappings}, max_depth \\ 40) do
		1..max_depth
		|> Enum.reduce(start |> base_frequencies, fn _, acc -> process_cycle(acc, mappings) end)
		|> then(fn {_,single} -> single end)
		|> Map.to_list
		|> IO.inspect
		|> Enum.min_max_by(fn {_, value} -> value end)
		|> then(fn {{_,min}, {_,max}} -> max-min end)
		|> IO.inspect
	end

	def process_cycle({frequencies, chars}, mappings) do
		frequencies
		|> Map.to_list
		|> Enum.reduce({%{}, chars}, fn x, acc -> add_frequencies(acc, mappings, x) end)
	end

	def add_frequencies({acc, chars}, mappings, {{x,y} = key, value}) do
		add_link = mappings[key]
		{acc
		|> add_frequency({{x,add_link}, value})
		|> add_frequency({{add_link,y}, value}),
		chars |> add_frequency({add_link, value})}
	end

	def add_frequency(acc, {key, value}) do
		case acc[key] do
			nil -> acc |> Map.put(key, value)
			x -> acc |> Map.put(key, value+x)
		end
	end


	def base_frequencies(input) do
		{input
		|> Enum.chunk_every(2, 1, :discard)
		|> Enum.map(fn [x,y] -> {x,y} end)
		|> Enum.frequencies,
		input |>
		Enum.frequencies}
	end
end

defmodule Part2_wrong do
	def solution({start, mappings}, max_depth \\ 40) do
		solution(start |> Enum.frequencies, start, mappings, max_depth)
		|> Enum.sort_by(fn {_,v} -> v end)
		|> Enum.map(fn {_,v} -> v end)
		|> then(fn x -> {
			x |> Enum.at(0), 
			x |> Enum.reverse |> Enum.at(0)} end)
		|> then(fn {l,h} -> h-l end)
		|> IO.inspect
	end

	def solution(frequencies, [fc,sc|tail], mappings, max_depth) do
		frequencies
		|> recursive_builder(fc, sc, mappings, 0, max_depth)
		|> solution([sc|tail], mappings, max_depth)
	end

	def solution(frequencies, [_], _, _) do
		frequencies
	end

	def recursive_builder(frequencies, f, s, mappings, depth, max_depth) do
		adding = mappings[{f,s}]
		case depth < max_depth do
			true -> case frequencies[adding] do
				nil -> frequencies |> Map.put(adding, 1)
				x -> frequencies |> Map.put(adding, x+1)
			end
			|> recursive_builder(f, adding, mappings, depth+1, max_depth)
			|> recursive_builder(adding, s, mappings, depth+1, max_depth)
			false -> frequencies
		end
	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n\n", trim: true)
		|> then(fn [x,y] -> {
			x |> String.split("", trim: true), 
			y |> String.split("\n", trim: true) |> Part1.create_map} end)

		input
		|> Part1.solution
		
		input
		|> Part2.solution
	end
end