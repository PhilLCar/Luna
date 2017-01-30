function rmComments(str)
   local nstr, i, op, cl, s = "", 1
   repeat
      s = str:sub(i, i + 1)
      if s == "--" then
	 i = i + 2
	 if str:sub(i, i) == "[" then
	    i = i + 1
	    op = 0
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
			i = i + 1
			s = str:sub(i, i)
		     until (i > #str or s ~= " " and s ~= "\n" and s ~= "\t")
		     break
		  end
	       end
	    else
	       repeat
		  i = i + 1
	       until (i > #str or str:sub(i, i) == "\n")
	    end
	 else
	    repeat
	       i = i + 1
	    until (i > #str or str:sub(i, i) == "\n")
	    i = i + 1
	 end
      else
	 nstr = nstr .. str:sub(i, i)
	 i = i + 1
      end
   until (i > #str)
   return nstr
end

function isOperator(str)
   ops = { "^", "-", "*", "/", "+", "..", ">", "<", ">=", "<=", "~=", "==",
	   "=", ".", ":", "(", ")", "[", "]", "{", "}", ",", ";", "\"", "'" }
   for i, v in ipairs(ops) do
      if str:sub(1, #v) == v then
	 return v
      end
   end
   return false
end
--[[
   TABLE DE PRIORITÉ
   ^ (r-assoc)
   not - (unaire)
   * /
   + -
   .. (r-assoc)
   > < >= <= ~= ==
   and
   or
   = (r-assoc)
]]
function split(str)
   local t, s, n, i, j, ls = "", "", "", 1, 1, {}
   while (i <= #str) do
      s = str:sub(i, i + 2)
      t = isOperator(s)
      if t then
	 if n ~= "" then
	    ls[j] = n
	    n = ""
	    j = j + 1
	 end
	 if t == "\"" then
	    repeat
	       n = n .. t
	       i = i + 1
	       t = str:sub(i, i)
	    until (t == "\"" or i >= #str)
	    ls[j] = n .. t
	    n = ""
	    i = i + 1
	    j = j + 1
	 elseif t =="\'" then
	    repeat
	       n = n .. t
	       i = i + 1
	       t = str:sub(i, i)
	    until (t == "\'" or i >= #str)
	    ls[j] = n .. t
	    n = ""
	    i = i + 1
	    j = j + 1
	 else
	    ls[j] = t
	    j = j + 1
	    i = i + #t
	 end
      else
	 t = s:sub(1, 1)
	 if t == " " or t == "\n" or t == "\t" then
	    if n ~= "" then
	       ls[j] = n
	       n = ""
	       j = j + 1
	    end
	 else
	    n = n .. t
	 end
	 i = i + 1
      end
   end
   if n ~= "" then
      ls[j] = n
   end
   return ls
end
   
function spaceNums(str)
   local i
end

function filter(str)
   local s, a = "", split(str)
   for i, v in ipairs(a) do
      s = s .. "«" .. v .. "»"
   end
   return s
end

function parenthesize(str)
   local line, nstr, i, s = "", "", 1
   while (i <= #str) do
      s = str:sub(i, i)
      if s == "\n" then
	 nstr = nstr .. filter(line) .. "\n"
	 line = ""
      else
	 line = line .. s
      end
      i = i + 1
   end
   return nstr
end


file = io.open("test.lua", "r")
text = file:read("all")
file:close()
print(parenthesize(rmComments(text)))
--print(23-23+234*2<243-3)

