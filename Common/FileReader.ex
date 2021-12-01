defmodule Input do
	def file(filedir) do
		File.read!(filedir <> "/input.txt")
	end
	def split(text, splitter) do
		text |> String.split(splitter, trim: true)
	end
end