function rmComments(str)
   local nstr, i, op, cl, s = "", 0, 0
   repeat
      i = i + 1
      s = str:sub(i, i + 1)
      if s == "--" then
	 i = i + 2
	 if str:sub(i, i) == "[" then
	    i = i + 1
	    while str:sub(i, i) == "=" do
	       op = op + 1
	       i = i + 1
	    end
	    if str:sub(i, i) == "[" then
	       while i < #str do
		  repeat
		     i = i + 1
		  until (i == #str or str:sub(i, i) == "]")
		  i = i + 1
		  cl = 0
		  while str:sub(i, i) == "=" do
		     cl = cl + 1
		     i = i + 1
		  end
		  if cl == op and str:sub(i, i) == "]" then
		     repeat
			s = str:sub(i, i)
			i = i + 1
		     until (i > #str or s ~= " " and s ~= "\n" and s ~= "\t")
		     break
		  end
	       end
	    else
	       repeat
		  i = i + 1
		  s = str:sub(i, i)
	       until (i > #str or s == "\n")
	    end
	 end
      else
	 nstr = nstr .. str:sub(i, i)
      end
   until (i > #str)
end
		  
