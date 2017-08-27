io = {}

io.output = function (filename)
   return _io_output(filename)
end

io.input = function (filename)
   return _io_input(filename)
end

io.stdin = io.input(nil)
io.stdout = io.output(nil)
io.stderr = _get_stderr()

io.write = function (...)
   local p = {...}
   for i = 1, #p do
      _write(p[i], true)
   end
end

io.read = function (...)
   _set_nargs(2)
   return _io_read(nil, ...)
end

io.open = function (filename, mode)
   if not mode then mode = "r" end
   return _io_open(filename, mode)
end

io.popen = function (procname, mode)
   if not mode then mode = "r" end
   return _io_popen(procname, mode)
end

io.close = function (file)
   _io_close(file)
end

io.flush = function (file)
   _io_flush(file)
end

io.type = function (file)
   return _io_type(file)
end

io.lines = function (filename)
   return _io_lines(filename)
end
