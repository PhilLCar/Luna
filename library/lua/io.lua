io = {}

io.write = function(...)
   local p = {...}
   for i = 1, #p do
      _print(p[i])
      if i ~= #p then
	 _print("\t")
      end
   end
end

function print(...)
   io.write(...)
   _print("\n")
end
