string = {}

string.sub = function (str, start, finish)
   return _s_sub(str, start, finish)
end

string.find = function (str, match)
   return _s_find(str, match)
end

-- Generates string with integer numbers
string.char = function (...)
end

-- Returns bytes of a function
string.dump = function (func)
   
end

-- Formats a string using the format specifier

string.format = function (specif, ...)
   local ret = ""
   local args = {...}
   local j, t = 1, 1
   for i = 1, #args do
      while specif:sub(j, j) ~= "%" do
	 j = j + 1
      end
      while j <= #specif and specif:sub(j + 1, j + 1) ~= "%" do
	 j = j + 1
      end
      ret = ret .. _format_c(specif:sub(t, j), args[i])
      j = j + 1
      t = j
   end
   return ret
end

