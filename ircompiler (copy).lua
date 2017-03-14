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
      token, i = nexttoken(str, i)
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

function scope(str, i, multi)
   local final, s = ""
   s, i = nexttoken(str, i)
   level = level + 1
   stack[level] = {}
   stack[level]["size"] = 0
   while s do
      if s == "if" then
	 s, i = nexttoken(str, i)
	 scopes["if"] = scopes["if"] + 1
	 final = final .. "if\t" .. tostring(scopes["if"]) .. "\n" ..
	 peval(s) .. "then\t" .. tostring(scopes["if"]) .. "\n"
	 s, i = nexttoken(str, i)
	 if s ~= "then" then
	    print("error\n")
	 end
	 s, i = scope(str, i, 0)
	 final = final .. s
	 s, i = nexttoken(str, i)
      elseif s == "elseif" then
	 s, i = nexttoken(str, i)
	 scopes["if"] = scopes["if"] + 1
	 place = place - stack[level]["size"]
	 final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n" ..
	 "else\t" .. tostring(scopes["if"] - 1) .. "\nif\t" .. tostring(scopes["if"]) .. "\n" ..
	 peval(s) .. "then\t" .. tostring(scopes["if"]) .. "\n"
	 stack[level] = {}
	 stack[level]["size"] = 0
	 s, i = scope(str, i, "iend\t" .. tostring(scopes["if"]) .. "\n", level)
	 final = final .. s
	 s, i = nexttoken(str, i)
      elseif s == "else" then
	 place = place - stack[level]["size"]
	 final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n" ..
	 "else\t" .. tostring(scopes["if"]) .. "\n"
	 stack[level] = {}
	 stack[level]["size"] = 0
	 s, i = scope(str, i, "", level)
	 final = final .. s
	 s, i = nexttoken(str, i)
      elseif s == "end" then
	 if fake == true or fake == false then
	    place = place - stack[level]["size"]
	    if fake then
	       final = final .. name .. "free\t" .. tostring(stack[level]["size"]) .. "\n"
	    else
	       final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n" .. name
	    end
	    stack[level] = nil
	    level = level - 1
	    return final, i
	 else
	    if level == fake then
	    
	    end
	    final = final .. name
	    if fake == 0 then
	       return final, i
	    else
	       return final, i - 4
	    end
	 end
      elseif s == "until" then
	 s, i = nexttoken(str, i)
	 place = place - stack[level]["size"]
	 final = final .. peval(s) .. "rend\t" .. name .. "\n" .. "free\t"
	    .. tostring(stack[level]["size"]) .. "\n"
	 stack[level] = nil
	 level = level - 1
	 return final, i
      elseif s == "while" then
	 s, i = nexttoken(str, i)
	 scopes["while"] = scopes["while"] + 1
	 final = final .. "while\t" .. tostring(scopes["while"]) .. "\n" ..
	 peval(s) .. "wdo\t" .. tostring(scopes["while"]) .. "\n"
	 -- ASSERT
	 s, i = nexttoken(str, i) -- SHOULD BE "do"
	 if s ~= "do" then
	    print("error")
	 end
	 level = level + 1
	 stack[level] = {}
	 stack[level]["size"] = 0
	 s, i = scope(str, i, "wend\t" .. tostring(scopes["while"]) .. "\n", true)
	 final = final .. s
	 s, i = nexttoken(str, i)
	 -- TODODODODODODODODODODODODODODODODODODO
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
	 level = level + 1
	 stack[level] = {}
	 stack[level]["size"] = 0
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
	    end
	    final = final .. "fdo\t" .. tostring(scopes["for"]) .. "\n" 
	 end
	 s, i = scope(str, i, "fend\t" .. tostring(scopes["for"]) .. "\n", true)
	 final = final .. s
      elseif s == "repeat" then
	 scopes["repeat"] = scopes["repeat"] + 1
	 final = final .. "repeat\t" .. tostring(scopes["repeat"]) .. "\n"
	 level = level + 1
	 stack[level] = {}
	 stack[level]["size"] = 0
	 s, i = scope(str, i, tostring(scopes["repeat"]), level)
	 final = final .. s
	 s, i = nexttoken(str, i)
	 --TODODODODODODODODODO
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
	 level = level + 1
	 stack[level] = {}
	 stack[level]["size"] = 0
	 s, i = scope(str, i, "dend\t" .. tostring(scopes["do"]) .. "\n", false)
	 final = final .. s
	 s, i = nexttoken(str, i)
      else
	 s, i = leval(str, i - #s - 1)
	 if s then
	    final = final .. s
	    s, i = nexttoken(str, i)
	 end
      end
   end
   place = place - stack[level]["size"]
   if stack[level]["size"] > 0 then
      final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n"
   end
   stack[level] = nil
   level = level - 1
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
	print (x)
	print (y)
end]]

--print(peval("((((2 + 3) - (((4 * (- 4)) ^ 5) ^ 9)) > 2) and 1)"))
file = io.open("unit-tests/test.lir", "w+")
file:write(scope(test2, 0, "", false))
print(scope(test2, 0, "", false))
file:close()

--[[
        elseif (1 == 3) then
                 x = 1
        elseif (1 == 4) then
                 x = 1]]
