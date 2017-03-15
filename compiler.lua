stack = {}
level = 1
place = 0
stack[level] = {}
stack[level]["size"] = 0

scopes = {}
scopes["if"] = 0
scopes["while"] = 0
scopes["for"] = 0
scopes["repeat"] = 0
scopes["do"] = 0
scopes["function"] = 0

--duplicate!!!
function isReserved(str)
   local ops = { "local", "or", "and", "not", "for", "in", "do", "while", "repeat",
		 "until", "if", "elseif", "else", "then", "end", "function" }
   for i, v in ipairs(ops) do
      if str == v then
	 return v
      end
   end
   return false
end

--duplicate!!!
function isOperator(str)
   local ops = { "^", "-", "*", "/", "+", "..", ">", "<", ">=", "<=", "~=", "==",
		 "=", ".", ":", "[", "]", "{", "}", ",", ";", "\"", "(", ")" }
   for i, v in ipairs(ops) do
      if str == v then
	 return v
      end
   end
   return false
end

ops = {}
ops["+"] = "add"
ops["-"] = "sub"
ops["--"] = "neg"
ops["*"] = "mul"
ops["/"] = "div"
ops["^"] = "exp"
ops[".."] = "concat"
ops[">"] = "gt"
ops["<"] = "lt"
ops[">="] = "gte"
ops["<="] = "lte"
ops["=="] = "eq"
ops["~="] = "neq"
ops["and"] = "and"
ops["or"] = "or"

function isNum(str)
   local s = str:byte(1, 1)
   return s >= 48 and s <= 58
end

function isString(str)
   local s = str:sub(1, 1)
   return s == "\"" or s == "\'" or str:sub(1, 2) == "[["
end

function isParenthesized(str)
   return str:sub(1, 1) == "(" --and str:sub(#str, #str) == ")"
end

function isBracketed(str)
   return str:sub(1, 1) == "[" --and str:sub(#str, #str) == "]"
end

function nexttoken(str, i)
   local j, word, s = 0, ""
   while i <= #str do
      i = i + 1
      s = str:sub(i, i)
      if s == "\n" or s == "\t" or s == " " then
	 if word ~= "" then
	    return word, i
	 end
      elseif s == "(" then
	 j = 1
	 word = word .. s
	 repeat
	    i = i + 1
	    s = str:sub(i, i)
	    word = word .. s
	    if s == "(" then
	       j = j + 1
	    elseif s == ")" then
	       j = j - 1
	    end
	 until i > #str or j == 0
      elseif s == "\"" or s == "\'" then
	 j = s
	 word = word .. s
	 repeat
	    i = i + 1
	    s = str:sub(i, i)
	    word = word .. s
	 until i > #str or j == s
      else
	 word = word .. s
      end
   end
   if word == "" then
      return false, i
   else return word, i
   end
end

function nextline(str, i)
   local j, word, s = 0, ""
   while i <= #str do
      i = i + 1
      s = str:sub(i, i)
      if s == "\n" then
	 if word ~= "" then
	    return word, i
	 end
      else
	 word = word .. s
      end
   end
   if word == "" then
      return false, i
   else return word, i
   end
end

function peval(str)
   local i, k, s, op, final, call = 0, 0, "", "", "", false
   while i <= #str do
      s, i = nexttoken(str, i)
      if not s then break
      end
      if isParenthesized(s) then
	 if call then
	    final = final .. feval(s)
	 else
	    final = final .. peval(s:sub(2, #s - 1))
	 end
	 k = k + 1
	 call = false
      elseif isBracketed(s) then
	 final = final .. peval(s:sub(2, #s - 1)) .. "index\n"
	 call = true
      elseif isNum(s) then
	 final = final .. "int\t" .. s .. "\n"
	 k = k + 1
	 call = false
      elseif isOperator(s) or isReserved(s) then
	 if k == 0 and s == "-" then
	    op = "--"
	 else
	    op = s
	 end
	 call = false
      elseif isString(s) then
	 final = final .. "string\t" .. s .. "\n"
	 k = k + 1
	 call = false
      elseif s == "true" or s == "false" then
	 final = final .. "bool\t" .. s .. "\n"
	 k = k + 1
	 call = false
      else
	 call = get(s)
	 if call then
	    final = final .. "ref\t" .. tostring(call) .. "\n"
	 else
	    final = final .. "var\t" .. s .. "\n"
	 end
	 k = k + 1
	 call = true
      end
   end
   if ops[op] then
      final = final .. ops[op] .. "\n"
   end
   return final
end

function feval(str)
   local i, k, final, s = 0, 1, ""
   str = str:sub(2, #str - 1)
   if str == "" then
      return "args\t0\n"
   end
   repeat
      s, i = nexttoken(str, i)
      if not s then break
      elseif s == "," then
	 k = k + 1
      else
	 final = final .. peval(s)
      end
   until false
   return "args\t" .. tostring(k) .. "\n" .. final .. "call\n"
end

function eeval(str)
   return _eeval(str, false)
end

function _eeval(str, forloop)
   local i, j, k, final, token = 0, 0, 1, ""
   token, i = nexttoken(str, i)
   if token == "local" or forloop then
      -- def/local mode
      if token == "local" then token, i = nexttoken(str, i) end
      while token and token ~= "=" do
	 if token == "," then
	    k = k + 1
	 else
	    place = place + 1
	    stack[level]["size"] = stack[level]["size"] + 1
	    stack[level][token] = place
	 end
	 token, i = nexttoken(str, i)
      end
      final = "sets\t" .. tostring(k) .. "\n" .. final
      j = 0
      while j <= k do
	 token, i = nexttoken(str, i)
	 if not token then break end
	 if token ~= "," then
	    final = final .. peval(token)
	    j = j + 1
	 end
      end
      return final .. "stack\n"
   else
      -- access/global mode
      while token and token ~= "=" do
	 if token == "," then
	    k = k + 1
	 else
	    j = get(token)
	    if j then
	       final = final .. "ref\t" .. tostring(j) .. "\n"
	    else
	       final = final .. "var\t" .. token .. "\n"
	    end
	 end
	 token, i = nexttoken(str, i)
      end
      final = "modif\t" .. tostring(k) .. "\n" .. final
      j = 0
      while j <= k do
	 token, i = nexttoken(str, i)
	 if not token then break end
	 if token ~= "," then
	    final = final .. peval(token)
	    j = j + 1
	 end
      end
      return final .. "place\n"
   end
end

function leval(str, i)
   local j = 0
   str, i = nextline(str, i)
   if not str then return str end
   while j < #str do
      j = j + 1
      if str:sub(j, j + 2) == " = " or str:sub(j, j + 5) == "local" then
	 return eeval(str), i
      end
   end
   return peval(str), i
end

function get(name)
   local s
   for i = level, 1, -1 do
      s = stack[i][name]
      if s then
	 return place - s
      end
   end
   return false
end

function free()
   local final = ""
   place = place - stack[level]["size"]
   if stack[level]["size"] > 0 then
      final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n"
   end
   stack[level] = nil
   level = level - 1
   return final
end

function alloc()
   level = level + 1
   stack[level] = {}
   stack[level]["size"] = 0
end

function scope(str, i)
   local final, s = ""
   s, i = nexttoken(str, i)
   alloc()
   
   while s do
      
      if s == "if" then
	 local count
	 s, i = nexttoken(str, i)
	 scopes["if"] = scopes["if"] + 1
	 count = scopes["if"]
	 final = final .. "if\t" .. tostring(count) .. "\n" ..
	 peval(s) .. "then\t" .. tostring(count) .. "\n"
	 --- Assertion
	 s, i = nexttoken(str, i)
	 if s ~= "then" then
	    print("error\n")
	 end
	 s, i = scope(str, i)
	 final = final .. s .. free()
	 s, i = nexttoken(str, i)
	 while s == "elseif" do
	    alloc()
	    s, i = nexttoken(str, i)
	    scopes["if"] = scopes["if"] + 1
	    final = final .. "else\t" .. tostring(scopes["if"] - 1) .. "\n" ..
	    "if\t" .. tostring(scopes["if"]) .. "\n" ..
	    peval(s) .. "then\t" .. tostring(scopes["if"]) .. "\n"
	    --- Assertion
	    s, i = nexttoken(str, i)
	    if s ~= "then" then
	       print("error\n")
	    end
	    s, i = scope(str, i)
	    final = final .. s .. free()
	    s, i = nexttoken(str, i)
	 end
	 if s == "else" then
	    alloc()
	    final = final .. "else\t" .. tostring(scopes["if"]) .. "\n"
	    s, i = scope(str, i + 4)
	    final = final .. s .. free()
	 end
	 for j = scopes["if"], count, -1 do
	    final = final .. "iend\t" .. tostring(j) .. "\n"
	 end

	 
      elseif s == "elseif" then
	 return final, i - 7

	 
      elseif s == "else" then
	 return final, i - 7

	 
      elseif s == "repeat" then
	 scopes["repeat"] = scopes["repeat"] + 1
	 final = final .. "repeat\t" .. tostring(scopes["repeat"]) .. "\n"
	 s, i = scope(str, i)
	 final = final .. s .. free()
	 s, i = nexttoken(str, i)
	 final = final .. peval(s) .. "rend\t" .. tostring(scopes["repeat"]) .. "\n"

	 
      elseif s == "until" then
	 return final, i

	 
      elseif s == "while" then
	 s, i = nexttoken(str, i)
	 scopes["while"] = scopes["while"] + 1
	 final = final .. "while\t" .. tostring(scopes["while"]) .. "\n" ..
	 peval(s) .. "wdo\t" .. tostring(scopes["while"]) .. "\n"
	 --- Assertion
	 s, i = nexttoken(str, i)
	 if s ~= "do" then
	    print("error")
	 end
	 s, i = scope(str, i)
	 final = final .. s .. free() .. "wend\t" .. tostring(scopes["while"]) .. "\n"

	 
      elseif s == "for" then
	 local j, k, args, bin, ain = i, 0, {}, false
	 s, i = nexttoken(str, i)
	 args[k] = ""
	 while s ~= "do" do
	    if s == "in" then
	       bin = str:sub(j, i - 3)
	       j = i
	    end
	    if s ~= "," then
	       if args[k] ~= "" then
		  args[k] = args[k] .. " " .. s
	       else
		  args[k] = s
	       end
	    else
	       print(args[k])
	       k = k + 1
	       args[k] = ""
	    end
	    s, i = nexttoken(str, i)
	 end
	 ain = str:sub(j, i - 3)
	 scopes["for"] = scopes["for"] + 1
	 if bin then
	    final = final .. "forin\t" .. tostring(scopes["for"]) .. "\n" ..
	       _eeval(bin, true) .. peval(ain) ..
	       "fdo\t" .. tostring(scopes["for"]) .. "\n" 
	 else
	    final = final .. "for\t" .. tostring(scopes["for"]) .. "\n" ..
	    _eeval(args[0], true) .. peval(args[1]) .. "cond\n"
	    if args[2] ~= nil then
	       final = final .. peval(args[2])
	    else
	       final = final .. "int\t1\n"
	    end
	    final = final .. "fdo\t" .. tostring(scopes["for"]) .. "\n" 
	 end
	 s, i = scope(str, i)
	 final = final .. s .. free() .. "fend\t" .. tostring(scopes["for"]) .. "\n"
	 

      elseif s == "function" then
	 s, i = nexttoken(str, i)
	 scopes["repeat"] = scopes["repeat"] + 1
	 final = final .. "repeat\t" .. tostring(scopes["repeat"]) .. "\n"
	 stack.level = stack.level + 1
	 stack[stack.level] = {}
	 s, i = scope(str, i, tostring(scopes["repeat"]), level)
	 final = final .. s

	 
      elseif s == "do" then
	 scopes["do"] = scopes["do"] + 1
	 final = final .. "do\t" .. tostring(scopes["do"] .. "\n")
	 s, i = scope(str, i)
	 final = final .. s .. free() .. "dend\t" .. tostring(scopes["do"]) .. "\n"

	 
      elseif s == "end" then
	 return final, i

	 
      else
	 s, i = leval(str, i - #s - 1)
	 if s then
	    final = final .. s
	 end
      end
      
      s, i = nexttoken(str, i)
   end
   
   free()
   return final
end

test = "((((2 + 3) - (((4 * (- 4)) ^ 5) ^ 9)) > 2) and 1)"
test2 = [[print ("a")
io ["write"] ("\n")
do
	print ("Hello World!")
	local x , y = ((((2 + 3) - (((4 * (- 4)) ^ 5) ^ 9)) > 2) and 1) , "test"
	y = y ["sub"] (y , 1 , 2)
        if (1 == 2) then
                 x = 3
        elseif (1 == 3) then
                 x = 1
        elseif (1 == 4) then
                 x = 1
        else
                 x = 2
        end
        repeat
                 x = 1
        until (x == 1)
        while (y == "test") do
                 y = 0
        end
        for i = 0 , 10 , 1 do
                 x = i
        end
        for i , j in ipairs (y) do
        end
        function test (a, ...)
                 x = a
        end
	print (x)
	print (y)
end]]

--print(peval("((((2 + 3) - (((4 * (- 4)) ^ 5) ^ 9)) > 2) and 1)"))
file = io.open("unit-tests/simple_add2.pp.lua", "r")
test = file:read("all")
file:close()
file = io.open("unit-tests/simple_add2.lir", "w+")
file:write(scope(test, 0))
--print(scope(test2, 0))
file:close()

--[[
        elseif (1 == 3) then
                 x = 1
        elseif (1 == 4) then
                 x = 1]]
