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
   print("<<" .. str .. ">>")
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
   if op and op ~= "" then
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
   local i, j, k, final, token = 0, 0, 1, ""
   token, i = nexttoken(str, i)
   if token == "local" then
      -- def/local mode
      while token and token ~= "=" do
	 if token == "," then
	    k = k + 1
	 else
	    j = get(token)
	    if j then
	       final = final .. "ref\t" .. tostring(j) .. "\n"
	    else
	       place = place + 1
	       stack[level]["size"] = stack[level]["size"] + 1
	       stack[level][token] = place
	       final = final .. "ref\t" .. tostring(place) .. "\n"
	    end
	 end
      end
      final = "sets\t" .. tostring(k) .. "\n" .. final
      while j <= k do
	 token, i = nexttoken(str, i)
	 if not token then return final end
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
      end
      final = "sets\t" .. tostring(k) .. "\n"
      while j <= k do
	 token, i = nexttoken(str, i)
	 if not token then return final end
	 if token ~= "," then
	    final = final .. peval(token)
	    j = j + 1
	 end
      end
      return final .. "stack\n"
   end
end

function leval(str, i)
   local j = 0
   str, i = nextline(str, i)
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
	 return s
      end
   end
   return false
end

function scope(str, i, name, fake)
   local final, s = ""
   s, i = nexttoken(str, i)
   if s == "if" then
      s, i = nexttoken(str, i)
      scopes["if"] = scopes["if"] + 1
      final = final .. "if\t" .. tostring(scopes["if"]) .. "\n" ..
      peval(s) .. "then\t" .. tostring(scopes["if"]) .. "\n"
      level = level + 1
      stack[level] = {}
      stack[level]["size"] = 0
      s, i = scope(str, i, "iend\t" .. tostring(scopes["if"]) "\n", false)
      final = final .. s
   elseif s == "elseif" then
      s, i = nexttoken(str, i)
      scopes["if"] = scopes["if"] + 1
      place = place - stack[level]["size"]
      final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n" ..
      "else\t" .. tostring(scopes["if"] - 1) .. "\n" ..
      peval(s) .. "then\t" .. tostring(scopes["if"]) .. "\n"
      stack[level] = {}
      stack[level]["size"] = 0
      s, i = scope(str, i, "iend\t" .. tostring(scopes["if"]) .. "\n", true)
      final = final .. s
   elseif s == "else" then
      place = place - stack[level]["size"]
      final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n" ..
      "else\t" .. tostring(scopes["if"]) .. "\n"
      stack[level] = {}
      stack[level]["size"] = 0
      s, i = scope(str, i, "", true)
      final = final .. s
   elseif s == "end" then
      place = place - stack[level]["size"]
      final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n" .. name
      stack[level] = nil
      level = level - 1
      if fake then
	 return final, i - 4
      else
	 return final, i
      end
   elseif s == "until" then
      s, i = nexttoken(str, i)
      place = place - stack[level]["size"]
      final = final .. "free\t" .. tostring(stack[level]["size"]) .. "\n" .. name ..
	 "\n" .. peval(s) .. "rend\t" .. name .. "\n"
      stack[level] = nil
      level = level - 1
   elseif s == "while" then
      s, i = nexttoken(str, i)
      scopes["while"] = scopes["while"] + 1
      final = final .. "while\t" .. tostring(scopes["while"]) .. "\n" ..
      peval(s) .. "wdo\t" .. tostring(scopes["while"]) .. "\n"
      -- ASSERT
      s, i = nexttoken(str, i) -- SHOULD BE "do"
      level = level + 1
      stack[level] = {}
      s, i = scope(str, i, "wend\t" .. tostring(scopes["while"]) "\n", false)
      final = final .. s
      -- TODODODODODODODODODODODODODODODODODODO
   elseif s == "for" then
      s, i = nexttoken(str, i)
      scopes["while"] = scopes["while"] + 1
      final = final .. "while" .. tostring(scopes["while"]) .. ":\n" ..
      peval(s) .. "wdo" .. tostring(scopes["while"]) .. ":\n"
      -- ASSERT
      s, i = nexttoken(str, i) -- SHOULD BE "do"
      stack.level = stack.level + 1
      stack[stack.level] = {}
      s, i = scope(str, i, "wend" .. tostring(scopes["if"]) "\n", false)
      final = final .. s
   elseif s == "repeat" then
      s, i = nexttoken(str, i)
      scopes["repeat"] = scopes["repeat"] + 1
      final = final .. "repeat\t" .. tostring(scopes["repeat"])
      level = level + 1
      stack[level] = {}
      s, i = scope(str, i, tostring(scopes["repeat"]), false)
      final = final .. s
      --TODODODODODODODODODO
   elseif s == "function" then
      s, i = nexttoken(str, i)
      scopes["repeat"] = scopes["repeat"] + 1
      final = final .. "repeat\t" .. tostring(scopes["repeat"])
      stack.level = stack.level + 1
      stack[stack.level] = {}
      s, i = scope(str, i, tostring(scopes["repeat"]), false)
      final = final .. s
      -- TODODODODODO
   elseif s == "do" then
      s, i = nexttoken(str, i)
      scopes["repeat"] = scopes["repeat"] + 1
      final = final .. "repeat\t" .. tostring(scopes["repeat"])
      stack.level = stack.level + 1
      stack[stack.level] = {}
      s, i = scope(str, i, tostring(scopes["repeat"]), false)
      final = final .. s
   else
      s, i = leval(str, i)
      final = final .. s
   end
   return s
end

test = "((((2 + 3) - (((4 * (- 4)) ^ 5) ^ 9)) > 2) and 1)"
test2 = [[print ("a")
io [ "write" ] ("\n")
do
	print ("Hello World!")
	local x , y = ((((2 + 3) - (((4 * (- 4)) ^ 5) ^ 9)) > 2) and 1) , "test"
	y = y [ "sub" ] (y, 1 , 2)
	print (x)
	print (y)
end]]

--print(peval("((((2 + 3) - (((4 * (- 4)) ^ 5) ^ 9)) > 2) and 1)"))
print(peval("(2 + print [\"x\"] (1 , \"Allo je m'appelle Jean!\" , 234 , alpha))"))
