os = {}

os.exit = function (code)
   if not code then code = -1 end
   return _o_exit(code)
end

os.execute = function (command)
   return _os_exec(command)
end
