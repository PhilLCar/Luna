stack = {}
level = 1
place = 0
stack[level] = {}
stack[level]["-"] = 0

scopes = {}
scopes["if"] = 0
scopes["while"] = 0
scopes["for"] = 0
scopes["repeat"] = 0
scopes["do"] = 0
scopes["function"] = 0

functions = ""

new = false
outside = false

--duplicate!!!
function isReserved(str)
   local ops = { "local", "or", "and", "not", "for", "in", "do", "while", "repeat",
		 "until", "if", "elseif", "else", "then", "end", "function", "nil", "return" }
   for i, v in ipairs(ops) do
      if str == v then
	 return v
      end
   end
   return false
end

--duplicate!!!
function isOperator(str)
   local ops = { "^", "-", "*", "/", "+", "..", ">", "<", ">=", "<=", "~=", "==", "%",
		 "~", "#", "=", ".", ":", "[", "]", "{", "}", ",", ";", "\"", "(", ")" }
   for i, v in ipairs(ops) do
      if str == v then
	 return v
      end
   end
   return false
end

ops = {}
ops["+"]   = "add"
ops["-"]   = "sub"
ops["%"]   = "mod"
ops["--"]  = "neg"
ops["*"]   = "mul"
ops["/"]   = "div"
ops["^"]   = "exp"
ops[".."]  = "concat"
ops[">"]   = "gt"
ops["<"]   = "lt"
ops[">="]  = "gte"
ops["<="]  = "lte"
ops["=="]  = "eq"
ops["~="]  = "neq"
ops["and"] = "and"
ops["or"]  = "or"
ops["not"] = "not"
ops["~"]   = "inv"
ops["#"]   = "len"
ops["nil"] = "nil"
ops["return"] = "return"

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

function isAccolade(str)
   return str:sub(1, 1) == "{" --and str:sub(#str, #str) == "]"
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
      elseif s == "{" then
	 j = 1
	 word = word .. s
	 repeat
	    i = i + 1
	    s = str:sub(i, i)
	    word = word .. s
	    if s == "{" then
	       j = j + 1
	    elseif s == "}" then
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
   local word, s = ""
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
   local func = false
   while i <= #str do
      s, i = nexttoken(str, i)
      if not s then break
      end
      if isParenthesized(s) then
	 if call then
	    final = final .. feval(s)
	    func = true
	 else
	    final = final .. peval(s:sub(2, #s - 1))
	 end
	 k = k + 1
	 call = false
      elseif isBracketed(s) then
	 if new then
	    new = false
	    final = final .. peval(s:sub(2, #s - 1)) .. "new\n"
	 else
	    final = final .. peval(s:sub(2, #s - 1)) .. "index\n"
	 end
	 stackdown()
	 call = true
      elseif isNum(s) then
	 stackup()
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
      elseif isAccolade(s) then
	 stackup()
	 final = final .. "create\n"
	 s = s:sub(2, #s)
	 local t, j = nexttoken(s, 1)
	 if t == "}" then
	    final = final .. "done\t0\n"
	 else
	    local count = 1
	    while t ~= false do
	       if t == "," then
		  final = final .. "item\t" .. tostring(count) .. "\n"
		  count = count + 1
	       elseif t == "}" then
		  final = final .. "item\t" .. tostring(count) .. "\n"
		  final = final .. "done\t" .. tostring(count) .. "\n"
	       else
		  final = final .. peval(t)
	       end
	       t, j = nexttoken(s, j)
	    end
	 end
      elseif isString(s) then
	 stackup()
	 final = final .. "string\t" .. s .. "\n"
	 k = k + 1
	 call = false
      elseif s == "true" or s == "false" then
	 stackup()
	 final = final .. "bool\t" .. s .. "\n"
	 k = k + 1
	 call = false
      else
	 call = get(s)
	 if call then
	    stackup()
	    final = final .. "ref\t" .. tostring(call) .. "\n"
	 else
	    stackup()
	    final = final .. "var\t" .. s .. "\n"
	 end
	 k = k + 1
	 call = true
      end
   end
   if ops[op] then
      final = final .. ops[op] .. "\n"
      if op ~= "~" and op ~= "--" and op ~= "not" and op ~= "#" and op ~= "nil" then
	 stackdown()
      end
   end
   return final
end

function feval(str)
   local i, k, final, s = 0, 1, ""
   str = str:sub(2, #str - 1)
   if str == "" then
      return "args\t0\n"
   end
   local tmp1, tmp2 = place, stack[level]["-"]
   repeat
      s, i = nexttoken(str, i)
      if not s then break
      elseif s == "," then
	 k = k + 1
      else
	 final = final .. peval(s)
      end
   until false
   place, stack[level]["-"] = tmp1, tmp2
   return "args\t" .. tostring(k) .. "\n" .. final .. "call\n"
end

function stackup()
   place = place + 1
   stack[level]["-"] = stack[level]["-"] + 1
end

function stackdown()
   place = place - 1
   stack[level]["-"] = stack[level]["-"] - 1
end

function eeval(str)
   return _eeval(str, false)
end

function _eeval(str, flag)
   local i, j, k, final, token, tmp1, tmp2 = 0, 0, 0, ""
   token, i = nexttoken(str, i)
   local localmode = token == "local" or flag == "forloop"
   local check = {}
   if localmode then
      -- def/local mode
      if token == "local" then token, i = nexttoken(str, i) end
      while token do
	 if token ~= "," then
	    place = place + 1
	    stack[level]["-"] = stack[level]["-"] + 1
	    stack[level][token] = place
	    k = k + 1
	 end
	 token, i = nexttoken(str, i)
	 if token ~= "," then
	    break
	 end
	 token, i = nexttoken(str, i)
      end
      tmp1 = stack[level]["-"]
      tmp2 = place
      stack[level]["-"] = stack[level]["-"] - k
      place = place - k
      final = "sets\t" .. tostring(k) .. "\n" .. final
   else
      -- access/global mode
      tmp1 = stack[level]["-"]
      tmp2 = place
      while token do
	 if token ~= "," then
	    final = final .. peval(token)
	    local tmp = token
	    token, i = nexttoken(str, i)
	    while token and (isBracketed(token) or isParenthesized(token)) do
	       if isBracketed(token) then
		  print("check: " .. tmp)
		  check[#check + 1] = tmp
	       end
	       final = final .. peval(token)
	       tmp = token
	       token, i = nexttoken(str, i)
	    end
	    final = final .. "store\n"
	    k = k + 1
	 end
	 if token ~= "," then
	    break
	 end
	 token, i = nexttoken(str, i)
      end
      final = "modif\n" .. final .. "sets\t" .. tostring(k) .. "\n"
   end
   j = 0
   stackup()
   stackup()
   if token == "=" then
      token, i = nexttoken(str, i)
      while token do
	 if token ~= "," then
	    if token == "function" then
	       local tmp
	       tmp, i = scope(str, i - 9, true)
	       final = final .. tmp
	    else
	       final = final .. peval(token)
	    end
	    token, i = nexttoken(str, i)
	    while token and (isBracketed(token) or isParenthesized(token)) do  
	       final = final .. peval(token)
	       token, i = nexttoken(str, i)
	    end
	    final = final .. "push\n"
	    j = j + 1
	 end
	 if token ~= "," then
	    break
	 end
	 token, i = nexttoken(str, i)
      end
   end
   if token then
      j = #token + 1
      print("\"" .. token .. "\"")
   end
   if localmode then
      final = final .. "stack\n"
   else
      final = final .. "place\n"
   end
   stack[level]["-"] = tmp1
   place = tmp2
   for j = 1, #check do
      final = final .. peval(check[j]) .. "check\n"
      stackdown()
   end
   return final, i - j
end

function concat(str)
   local final, token, i = "", nexttoken(str, 0)
   local k = 0
   if token and token == "return" then
      token, i = nexttoken(str, i)
   end
   while token do
      if token ~= "," then
	 final = final .. peval(token)
	 token, i = nexttoken(str, i)
	 while token and (isBracketed(token) or isParenthesized(token)) do
	    final = final .. peval(token)
	    token, i = nexttoken(str, i)
	 end
	 final = final .. "push\n"
	 k = k + 1
      end
      if token ~= "," then
	    break
      end
      token, i = nexttoken(str, i)
   end
   if token then
      i = i - #token - 1
   end
   return "sets\t" .. tostring(k) .. "\n" .. final .. "return\n", i
end

function func(str)
   local final, token, i = "", nexttoken(str, 0)
   local k = 0
   local varargs = false
   while token do
      if token == "..." then
	 token = "arg"
	 varargs = true
	 k = k - 1
      end
      if token ~= "," then
	 place = place + 1
	 stack[level]["-"] = stack[level]["-"] + 1
	 stack[level][token] = place
	 k = k + 1
      end
      token, i = nexttoken(str, i)
      if token ~= "," then
	 break
      end
      token, i = nexttoken(str, i)
   end
   local ret = "gen\t" .. tostring(k) .. "\n"
   if varargs then
      ret = ret .. "vargs\n"
   end
   return ret
end

function leval(str, i)
   local j, k = 0, i
   local s, i = nextline(str, i)
   print("«" .. s .. "»")
   if not s then return s end
   if s:find("=") and (s:find("=") ~= s:find("==")) or s:find("local") then
      s, i = eeval(str:sub(k, #str))
      return s, i + k - 1
   elseif s:find("return") and s:find(",") then
      s, i = concat(str:sub(k, #str))
      return s, i + k - 1
   end
   return peval(s), i
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
   place = place - stack[level]["-"]
   if stack[level]["-"] > 0 then
      final = final .. "free\t" .. tostring(stack[level]["-"]) .. "\n"
   end
   stack[level] = nil
   level = level - 1
   return final
end

function alloc()
   level = level + 1
   stack[level] = {}
   stack[level]["-"] = 0
end

function scope(str, i, ...)
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
	 stackdown()
	 --- Assertion
	 s, i = nexttoken(str, i)
	 if s ~= "then" then
	    print("error\n")
	 end
	 s, i = scope(str, i)
	 final = final .. s .. free()
	 s, i = nexttoken(str, i)
	 if s and s ~= "else" and s ~= "elseif" then
	    i = i - #s - 1
	 end
	 while s == "elseif" do
	    alloc()
	    s, i = nexttoken(str, i)
	    scopes["if"] = scopes["if"] + 1
	    final = final .. "else\t" .. tostring(scopes["if"] - 1) .. "\n" ..
	    "if\t" .. tostring(scopes["if"]) .. "\n" ..
	    peval(s) .. "then\t" .. tostring(scopes["if"]) .. "\n"
	    stackdown()
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
	    s, i = scope(str, i)
	    final = final .. s .. free()
	 end
	 for j = scopes["if"], count, -1 do
	    final = final .. "iend\t" .. tostring(j) .. "\n" --.. free()
	 end

	 
      elseif s == "elseif" then
	 return final, i - 7

	 
      elseif s == "else" then
	 return final, i - 5

	 
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
	    local t = _eeval(bin, "forloop")
	    final = final .. "forin\t" .. tostring(scopes["for"]) .. "\n" ..
	       t .. peval(ain) ..
	       "fdo\t" .. tostring(scopes["for"]) .. "\n" 
	 else
	    local t = _eeval(args[0], "forloop")
	    final = final .. "for\t" .. tostring(scopes["for"]) .. "\n" ..
	    t .. peval(args[1]) .. "cond\n"
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
	 scopes["function"] = scopes["function"] + 1
	 final = final .. "func\t" .. tostring(scopes["function"]) .. "\n"
	 functions = functions .. "def\t" .. tostring(scopes["function"]) ..
	    "\n" .. func(s:sub(2, #s - 1))
	 s, i = scope(str, i)
	 functions = functions .. s .. free() .. "fend\n"
	 if arg[1] then
	    return final, i
	 end

	 
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
   
   return final .. free() .. functions
end

local file = io.open(comp_file .. ".pp.lua", "r")
local text = file:read("all")
file:close()
file = io.open(comp_file .. ".lir", "w+")
file:write(scope(text, 0))
file:close()

