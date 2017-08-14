function print(...)
   local p = {...}
   for i = 1, #p do
      _print(p[i])
      if i ~= #p then
	 _print("\t")
      end
   end
   _print("\n")
end
