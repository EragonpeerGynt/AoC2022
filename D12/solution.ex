defmodule Main do
	def execute(day) do
		input = Input.file(day)
		|> String.split("\n", trim: true)
		
		input
		|> Part1.solution
		
		input
		|> Part2.solution
	end
end