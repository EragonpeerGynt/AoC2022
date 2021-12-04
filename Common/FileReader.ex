defmodule Input do
	def file(filedir) do
		File.read!(filedir <> "/input.txt")
	end
	def split(text, splitter) do
		text |> String.split(splitter, trim: true)
	end
end

defmodule Matrix do
	def transpose([]), do: []
	def transpose([[]|_]), do: []
	def transpose(a) do
		[Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
	end
end