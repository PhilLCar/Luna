--IO
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

io.open = function(filename, mode)
   return _io_open(filename, mode)
end

io.popen = function(procname)
   return _io_popen(procname)
end

-- MISC
function print(...)
   io.write(...)
   _print("\n")
end

