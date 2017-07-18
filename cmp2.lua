function isWhitespace(c)
   return c == " " or c == "\t" or c == "\n"
end

function nextexpr(str, i)
   local c, ret = 0, ""
   local i, s   = 0
   while true do
      i = i + 1
      if i > #str then return false, i
      s = str:sub(i, i)
      if not isWhitespace(s) then
	 ret = ret .. s
	 if s == "(" then
	    c = c + 1
	 elseif s == ")" then
	    c = c - 1
	 end
      end
      if ret ~= "" and c == 0 then break end
   end
   return ret, i
end

function compile(str, i)
   local ret, tmp = ""
   local expr
   while true do
      expr, i = nextexpr(str, i)
      if not expr then break end

      if expr == "end" then
	 return ret, i
      end

      if expr == "if" then

      elseif expr == "elseif" then

      elseif expr == "do" then

      elseif expr == "for" then

      elseif expr == "while" then

      elseif expr == "repeat" then

      elseif expr == "function" then

      elseif expr == "{" then

      else

      end
   end
   return ret
end
   
