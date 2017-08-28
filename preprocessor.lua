-- Constant
local _SPACE = "   "

--------------------------------------------------------------------------------
-- Error managment values
--------------------------------------------------------------------------------
local typerr = "Unknown"

--------------------------------------------------------------------------------
-- Miscellaneous functions
--------------------------------------------------------------------------------
-- String generation function
function strgen(str, n)
   local ret = ""
   for i = 1, n do
      ret = ret .. str
   end
   return ret
end

function isWhitespace(str)
   if str == " "  or
      --str == "\n" or !!Conserver les choix de l'utilisateur dans le placement de "\n"
      str == "\r" or
      str == "\t"
   then
      return true
   end
   return false
end

function isOperator(str)
   if -- Single char operators
      str == "-"  or
      str == "+"  or
      str == "/"  or
      str == "*"  or
      str == "~"  or
      str == "^"  or
      str == "."  or
      str == ":"  or
      str == "<"  or
      str == ">"  or
      str == "#"  or
      str == "%"  or
      str == "~"  or
      str == "\\" or
      str == "|"  or
      str == "&"  or
      -- 2 char operators
      str == "~=" or
      str == ">=" or
      str == "<=" or
      str == "==" or
      str == ".." or
      str == "or" or
      str == ">>" or
      str == "<<" or
      str == "!=" or
      str == "^^" or
      -- 3 char operators
      str == "and"  or
      str == "not"  or
      str == "==="  or
      str == ">>>"
   then
      return true
   end
   return false
end

function isPunctuation(str)
   return str == "=" or str == "," or str == ";"
end

function isDelimiter(str)
   if -- Single char delimiters
      str == "{"  or
      str == "}"  or
      str == "("  or
      str == ")"  or
      str == "\"" or
      str == "'"  or
      str == "["  or
      str == "]"  or
      -- 2 char delimiters
      str == "[[" or
      str == "[=" or
      str == "=]" or
      str == "]]"
   then
      return true
   end
   return false
end

function isEnv(str)
   if str == "function"  or
      str == "if"        or
      str == "then"      or
      str == "else"      or
      str == "elseif"    or
      str == "end"       or
      str == "for"       or
      str == "while"     or
      str == "do"        or
      str == "in"        or
      str == "repeat"    or
      str == "until"  
   then
      return true
   end
   return false
end

function isReserved(str)
   if str == "local"  or
      str == "break"  or
      str == "return"
   then
      return true
   end
   return false
end

function isVariable(str)
   if tonumber(str)    or
      isEnv(str)       or
      isReserver(str)  or
      isOperator(str)  or
      isDelimiter(str) or
      isPunctuation(str)
   then
      return false
   else
      return true
   end
end

--------------------------------------------------------------------------------
-- Parsing functions
--------------------------------------------------------------------------------

-- This function retrieves the next token from the file ignoring user format.
-- A token can be a value, a variable, an operator, etc...
function nexttoken(str, i)
   local ret, s = ""

   if i > #str then
      return false, i
   end
   s = str:sub(i, i)
   
   -- Removes whitespaces ahead of expression
   while isWhitespace(s) do
      i = i + 1
      if i > #str then
	 return false, i
      end
      s = str:sub(i, i)
   end

   -- ***Special cases*** (3 char)
   s = str:sub(i, i + 2)
   
   if s == "..." or isOperator(s) then
      return s, i + 3
   end

   -- ***Special cases*** (2 char)
   s = s:sub(1, 2)

   -- String parsing: [[]]
   if s == "[=" or s == "[[" then
      return strpar(str, i, false)

   -- Comment parsing
   elseif s == "--" then
      return compar(str, i)
      
   elseif isOperator(s) then
      return s, i + 2
   end

   -- ***Special cases*** (1 char)
   s = s:sub(1, 1)

   if s == "\n" then
      return s, i + 1

   -- String parsing: "" ''
   elseif s == "\"" or s == "'" then
      return strpar(str, i, s)
      
   elseif isOperator(s) or isDelimiter(s) or isPunctuation(s) then
      return s, i + 1

   elseif tonumber(s) then
      while
	 not isWhitespace(s) and
	 (not isOperator(s) or s == ".") and
	 not isDelimiter(s) and
	 not isPunctuation(s) and
	 s ~= "\n"
      do
	 ret = ret .. s
	 i = i + 1
	 if i > #str then
	    return ret, i
	 end
	 s = str:sub(i, i)
      end
      return ret, i
   end

   -- ***Regular case***
   while
      not isWhitespace(s) and
      not isOperator(s) and
      not isDelimiter(s) and
      not isPunctuation(s) and
      s ~= "\n"
   do
      ret = ret .. s
      i = i + 1
      if i > #str then
	 return ret, i
      end
      s = str:sub(i, i)
   end

   return ret, i
end

-- This function will ensure the expression read isn't empty
function readline(str, i, indent)
   local ret = ""
   local tmp, k = readexpr(str, i, indent)
   while tmp == "\n" do
      ret = ret .. "\n" .. strgen(_SPACE, indent + 1)
      i = k
      tmp, k = readexpr(str, i, indent)
   end
   return ret, i
end

-- This function parses the single next expression to be preprocessed
function readexpr(str, i, indent)
   local ret, token = ""
   local expr, j, c = {}, 0, 0
   local last, k = "", i
   local ti = i
   
   while true do
      token, k = nexttoken(str, i)
      if not token then return token, k end
      j = j + 1

      if isReserved(token)    or
	 isEnv(token)         or
	 isPunctuation(token) or
	 token == "{"         or
	 token == "}"
      then
	 if c == 0 then
	    if j == 1 then
	       return token, k
	    elseif last ~= "op" then
	       break
	    else
	       typerr = "Unexpected token \"" .. token .. "\""
	       helperror(i)
	    end
	 else
	    expr[j] = token
	    last = "op"
	 end
      elseif isDelimiter(token) then
	 if token == "(" or token == "[" --[[or token == "{"]] then c = c + 1
	 elseif token == ")" or token == "]" --[[or token == "}"]] then c = c - 1
	 end
	 expr[j] = token
	 last = "del"
      elseif isOperator(token) then
	 expr[j] = token
	 last = "op"
      elseif token == "\n" then
	 if last == "" then
	    return token, k
	 elseif last ~= "op" then
	    break
	 else
	    expr[j] = token
	 end
      elseif token:sub(1,1) == "\"" then
	 expr[j] = token
	 last = "str"
      else
	 if last == "var" then
	    typerr = "Syntax error, possibly missing an operator?"
	    helperror(i)
	 end
	 expr[j] = token
	 last = "var"
      end
      i = k
      if c == 0 then
	 ti = i
      end
   end

   if c ~= 0 then
      typerr = "Parenthesis mismatch."
      helperror(ti)
   end
   ret = scan(rmDot(expr), 1, nil, indent)
   return ret, i
end

function associate(array, left, unary, indent, ...)
   if unary then
      return comb1(array, indent, ...)
   else
      return comb2(array, left, indent, ...)
   end
end

-- Combing for unary operators
function comb1(arr, indent, ...)
   local i, j = 1
   local prev = true
   while i <= #arr do
      if prev and mem(arr[i], ...) then
	 j = i + 1
	 while mem(arr[j], "#", "-", "~", "not", "\n") do
	    j = j + 1
	 end
	 local ts
	 for k = j - 1, i do
	    if arr[k] == "\n" then
	       arr[j] =
		  "\n" .. strgen(_SPACE, indent + 1) .. array[j]
	    else
	       if not comp_flags.npc then
		  ts = trysolve(arr[k], arr[j])
	       end
	       if ts then
		  arr[j] = ts
	       else
		  arr[j] =
		     "(" .. arr[k] .. " " .. arr[j] .. ")"
	       end
	    end
	 end
	 for k = i, j - 1 do
	    arr[k] = nil
	 end
	 i = j
      end
      prev = arr[i]
      if isOperator(prev) or
	 isReserved(prev) or
	 isPunctuation(prev) or
	 isEnv(prev) or
	 prev == "(" or
	 prev == "{" or
	 prev == "["
      then
	 prev = true
      else
	 prev = false
      end
      i = i + 1
   end
   j = 0
   local newarr = {}
   for i, v in pairs(arr) do
      j = j + 1
      newarr[j] = v
   end
   return newarr
end

-- Combing for binary operators
function comb2(arr, left, indent, ...)
   local i, j, e, t
   if left then
      i, e, t = 1, #arr + 1, 1
   else
      i, e, t = #arr, 0, -1
   end
   while i ~= e do
      if mem(arr[i], ...) then
	 j = i + 1
	 while mem(arr[j], "#", "-", "~", "not", "\n") do
	    j = j + 1
	 end
	 local ts
	 for k = j - 1, i + 1, -1 do
	    if arr[k] == "\n" then
	       arr[j] =
		  "\n" .. strgen(_SPACE, indent + 1) .. arr[j]
	    else
	       if not comp_flags.npc then
		  ts = trysolve(arr[k], arr[j])
	       end
	       if ts then
		  arr[j] = ts
	       else
		  arr[j] =
		     "(" .. arr[k] .. " " .. arr[j] .. ")"
	       end
	    end
	 end
	 if not comp_flags.npc then
	    ts = trysolve(arr[i], arr[j], arr[i - 1])
	 end
	 if arr[i] == ":" then
	    arr[j] = arr[i - 1] .. " " .. arr[i] .. " " .. arr[j]
	 elseif ts and left then
	    arr[j] = ts
	 elseif left then
	    arr[j] = "(" .. arr[i - 1] .. " " .. arr[i] .. " " .. arr[j] .. ")"
	 elseif ts then
	    arr[i - 1] = ts
	 else
	    arr[i - 1] = "(" .. arr[i - 1] .. " " .. arr[i] .. " " .. arr[j] .. ")"
	 end
	 for k = i, j - 1 do
	    arr[k] = nil
	 end
	 if left then
	    arr[i - 1] = nil
	    i = j
	 else
	    arr[j] = nil
	    i = i - 1
	 end
      end
      i = i + t
   end
   j = 0
   local newarr = {}
   for i, v in pairs(arr) do
      j = j + 1
      newarr[j] = v
   end
   return newarr
end

-- Removing macros '.' and ':'
function rmDot(arr)
   local i = 1
   while i <= #arr do
      if arr[i] == "." then
	 arr[i + 1] = arr[i - 1] .. " [\"" ..  arr[i + 1] .. "\"]"
	 arr[i - 1] = nil
	 arr[i] = nil
	 i = i + 1
      end
      i = i + 1
   end
   j = 0
   local newarr = {}
   for i, v in pairs(arr) do
      j = j + 1
      newarr[j] = v
   end
   return newarr
end

-- The scanning function allows to correctly parenthesize expressions while keeping
-- user specified parentheses in place
function scan(array, start, stop, indent)
   local i, j = start, 1
   local newarr, ret = {}, ""
   while i <= #array do
      if array[i] ~= nil then
	 if array[i] == stop then
	    break
	    -- Calling
	 elseif mem(array[i], "(", "[", "{") or array[i]:sub(1, 1) == "\"" then
	    if array[i] == "(" then
	       ret, i = scan(array, i + 1, ")", indent)
	       if ret:sub(1, 1) ~= "(" then
		  ret = "(" .. ret .. ")"
	       else
		  local n, c = 0
		  for k = 1, #ret do
		     c = ret:sub(k, k)
		     if c == "(" or c == "{" then
			n = n + 1
		     elseif c == ")" or c == "}" then
			n = n - 1
		     elseif c == "," and n == 0 then
			ret = "(" .. ret .. ")"
			break
		     end
		  end
	       end
	       newarr[j] = ret
	    elseif array[i] == "[" then
	       ret, i = scan(array, i + 1, "]", indent)
	       newarr[j] = "[" .. ret .. "]"
	    elseif array[i] == "{" then
	       ret, i = scan(array, i + 1, "}", indent)
	       newarr[j] = preprocess("{ " .. ret .. " }")
	    else
	       newarr[j] = array[i]
	    end
	    local t = newarr[j - 1]
	    if j > 1 and
	       not isOperator(t)    and
	       not isReserved(t)    and
	       not isEnv(t)         and
	       not isPunctuation(t) and
	       not mem(t, "(", "[", "{", "\n")
	    then
	       newarr[j - 1] = newarr[j - 1] .. " " .. newarr[j]
	       newarr[j] = nil
	       j = j - 1
	    end
	 else
	    newarr[j] = array[i]
	 end
      end
      i = i + 1
      j = j + 1
   end
   ret = ""
   -- associate calls first
   newarr = associate(newarr, true , false, indent, ":")
   -- PRIORITY LEVELS --
   -- Level 0 - Bitwise       : << >> >>> | & ^^ ~ === != [left-associative ]
   newarr = associate(newarr, true , true , indent, "~")
   newarr = associate(newarr, true, false, indent, "<<", ">>", ">>>", "|", "&", "^^", "===", "!=", "~")
   -- Level 1 - Power         : ^                         [right-associative]
   newarr = associate(newarr, false, false, indent, "^")
   -- Level 2 - Unary         : - not #                   [left-associative ]
   newarr = associate(newarr, true , true , indent, "-", "not", "#")
   -- Level 3 - Multiplicative: * / % \                   [left-associative ]
   newarr = associate(newarr, true , false, indent, "*", "/", "%", "\\")
   -- Level 4 - Additive      : + -                       [left-associative ]
   newarr = associate(newarr, true , false, indent, "+", "-")
   -- Level 5 - Concatenation : ..                        [right-associative]
   newarr = associate(newarr, false, false, indent, "..")
   -- Level 6 - Boolean       : == ~= <= >= < >           [left-associative ]
   newarr = associate(newarr, true , false, indent, "==", "~=", "<=", ">=", "<", ">")
   -- Level 7 - Conjunction   : and                       [left-associative ]
   newarr = associate(newarr, true , false, indent, "and")
   -- Level 8 - Disjunction   : or                        [left-associative ]
   newarr = associate(newarr, true , false, indent, "or")
   

   for i, v in ipairs(newarr) do
      if v == "," then v = " , "
      elseif v == ":" then v = " : "
      elseif v == ";" then v = " ; "
      elseif v == "\n" then v = v .. strgen(_SPACE, indent + 1) end
      ret = ret .. v
   end
   return ret, i
end

function escape(str, i)
   local s, num = ""
   i = i + 1
   num = str:sub(i, i)
   if tonumber(num) then
      while tonumber(num) do
	 s = s .. num
	 i = i + 1
	 num = str:sub(i, i)
      end
      i = i - 1
      s = tonumber(s)
      num = 0
      local l = 1
      while s ~= 0 do
	 num = num + (s % 8) * l
	 s = s >> 3
	 l = l * 10
      end
   end
   return "\\" .. tostring(num), i;
end

-- Comment parsing
function compar(str, i)
   local s = str:sub(i + 2, i + 3)
   local line = str:sub(i - 1, i - 1) == "\n"
   if s == "[=" or s == "[[" then
      s, i = nexttoken(str, i + 2)
      s, i = nexttoken(str, i)
   else
      i = i + 3
      repeat
	 i = i + 1
	 s = str:sub(i, i)
      until i >= #str or s == "\n"
      s, i = nexttoken(str, i)
   end
   if line and s then
      if s ~= "\n" then
	 typerr = "Unexpected symbol " .. s .. "."
	 helperror(i)
      end
      s, i = nexttoken(str, i)
   end
   return s, i
end

-- String parsing
function strpar(str, i, t)
   local n, ret = 1, "\""
   
      if not t then
	 repeat
	    n = n + 1
	    i = i + 1
	    s = str:sub(i, i)
	 until s == "["
      end
      
      while true do
	 i = i + 1
	 if i > #str then
	    if t then
	       typerr = "String decleration reached end of file. Expected closing " .. t .. "."
	    else
	       typerr = "Reached end of file, expected closing brackets."
	    end
	    helperror(i)
	    break
	 end
	 s = str:sub(i, i)
	 if s == "\n" then
	    if not t then ret = ret .. "\\n" end
	    --ret = ret .. "\n"
	 elseif s == "\t" then
	    ret = ret .. "\\t"
	 elseif s == "\"" and t ~= s then
	    ret = ret .. "\\\""
	 elseif t and s == "\\" then
	    s, i = escape(str, i)
	    ret = ret .. s
	 elseif s == "]" and not t then
	    local m, tmp = 1, s
	    repeat
	       m = m + 1
	       i = i + 1
	       s = str:sub(i, i)
	       tmp = tmp .. s
	    until s == "]" or m > n
	    if m == n then
	       i = i + 1
	       ret = ret .. "\""
	       break
	    else
	       ret = ret .. tmp
	    end
	 elseif s == t then
	    ret = ret .. "\""
	    i = i + 1
	    break
	 else
	    ret = ret .. s
	 end
      end
      return ret, i
end

--------------------------------------------------------------------------------
-- Preprocessing
--------------------------------------------------------------------------------
----------------------------------------
-- Environment functions   ** Ajouter arrayenv si possible
----------------------------------------
-- These functions handle the various environments in which the preprocessor
-- can be run
function arrenv(str, i, line, indent, elif)
   local ret, tmp = line
   tmp, i, line = _preprocess(str, i, indent + 1, { "}" })
   ret = ret .. tmp .. line .. " "
   return ret, i
end

function ifenv(str, i, line, indent, elif)
   local ret, tmp = line
   tmp, i = readline(str, i, indent)
   ret = ret .. tmp
   tmp, i = readexpr(str, i, indent)
   ret = ret .. tmp .. " "
   tmp, i = readline(str, i, indent - 1)
   ret = ret .. tmp
   tmp, i = readexpr(str, i, indent)
   if tmp ~= "then" then
      typerr = "Syntax error, 'then' expected."
      helperror(i)
   end
   ret = ret .. tmp .. " "
   tmp, i, line = _preprocess(str, i, indent + 1, { "else", "end" })
   ret = ret .. tmp .. line .. " "
   if line:sub(-4, -1) == "else" then
      tmp, i, line = _preprocess(str, i, indent + 1, { "end" })
      ret = ret .. tmp .. line .. " "
   end
   if elif then
      return ret .. "\n", i - 4
   else
      return ret, i
   end
end

function doenv(str, i, line, indent, elif)
   local ret, tmp = line
   tmp, i, line = _preprocess(str, i, indent + 1, { "end" })
   ret = ret .. tmp .. line .. " "
   return ret, i
end

function forenv(str, i, line, indent, elif)
   local ret, tmp = line
   tmp, i, line = _preprocess(str, i, indent + 1, { "in", "do" })
   ret = ret .. tmp .. line .. " "
   if line:sub(-2, -1) == "in" then
      tmp, i, line = _preprocess(str, i, indent + 1, { "do" })
      ret = ret .. tmp .. line .. " "
   end
   tmp, i = doenv(str, i, "", indent, elif)
   return ret .. tmp, i
end

function wenv(str, i, line, indent, elif)
   local ret, tmp = line
   tmp, i = readline(str, i, indent)
   ret = ret .. tmp
   tmp, i = readexpr(str, i, indent)
   ret = ret .. tmp .. " "
   tmp, i = readline(str, i, indent - 1)
   ret = ret .. tmp
   tmp, i = readexpr(str, i, indent)
   if tmp ~= "do" then
      typerr = "Syntax error, 'do' expected."
      helperror(i)
   end
   ret = ret .. tmp
   tmp, i = doenv(str, i, "", indent, elif)
   return ret .. tmp, i
end

function repenv(str, i, line, indent, elif)
   local ret, tmp = line
   tmp, i, line = _preprocess(str, i, indent + 1, { "until" })
   ret = ret .. tmp .. line .. " "
   tmp, i = readline(str, i, indent)
   ret = ret .. tmp
   tmp, i = readexpr(str, i, indent)
   ret = ret .. tmp .. " "
   return ret, i
end

function funenv(str, i, line, indent, elif)
   local ret, tmp = line
   tmp, i = readline(str, i, indent)
   ret = ret .. " " .. tmp
   tmp, i = readexpr(str, i, indent)
   if tmp:sub(1, 1) ~= "(" then
      typerr = "No parameter declaration"
      helperror(i)
   end
   ret = ret .. tmp .. " "
   tmp, i, line = _preprocess(str, i, indent + 1, { "end" })
   ret = ret .. tmp .. line .. " "
   return ret, i
end

-- Preprocessing function (Main function)
function preprocess(str)
   return _preprocess(str, 1, 0, {})
end

function _preprocess(str, i, indent, stops)
   local ret = "", 1
   local line, tmp = true
   local nl, rval = 0, false -- strgen("  ", indent)
   local loc = false
   
   while true do
      line, i = readexpr(str, i, indent)
      if not line then break end
      
      for n, stop in ipairs(stops) do
	 if line == stop then
	    return ret, i, strgen(_SPACE, nl - 1) .. line
	 end
      end
      
      if line == "end" then
	 if #stops == 0 then
	    typerr = "<eof> expected near 'end'."
	 else
	    typerr = "Unexpectedly reached \"end\"; was expecting \"" .. stops[1] .. "\""
	    for j = 2, #stops do
	       typerr = typerr .. ", or \"" .. stops[j] .. "\""
	    end
	    typerr = typerr .. "."
	 end
	 helperror(i)
      elseif line == "}" then
	 typerr = "Closing non-existant table declaration."
	 helperror(i)
      end

      ---------- NL ----------
      if line == "\n" then
	 ret = ret .. line
	 nl = indent
	 rval = false
      
      ---------- IF  ----------
      elseif line == "if" then
	 line = strgen(_SPACE, nl) .. line .. " "
	 tmp, i = ifenv(str, i, line, indent, false)
	 ret = ret .. tmp
	 
      elseif line == "elseif" then
	 line = strgen(_SPACE, nl - 1) .. "else if "
	 tmp, i = ifenv(str, i, line, indent, true)
	 ret = ret .. tmp

      ---------- DO  ----------
      elseif line == "do" then
	 line = strgen(_SPACE, nl) .. line .. " "
	 tmp, i = doenv(str, i, line, indent, false)
	 ret = ret .. tmp

      ---------- FOR ----------
      elseif line == "for" then
	 line = strgen(_SPACE, nl) .. line .. " "
	 tmp, i = forenv(str, i, line, indent, false)
	 ret = ret .. tmp

      ---------- WHL ----------
      elseif line == "while" then
	 line = strgen(_SPACE, nl) .. line .. " "
	 tmp, i = wenv(str, i, line, indent, false)
	 ret = ret .. tmp

      ---------- RPT ----------
      elseif line == "repeat" then
	 line = strgen(_SPACE, nl) .. line .. " "
	 tmp, i = repenv(str, i, line, indent, false)
	 ret = ret .. tmp

      ---------- FCT ----------
      elseif line == "function" then
	 if not rval then
	    tmp, i = readline(str, i, indent)
	    tmp, i = nexttoken(str, i)
	    if isOperator(tmp)      or
	       isEnv(tmp)           or
	       isReserved(tmp)      or
	       isPunctuation(tmp)   or
	       tmp:sub(1, 1) == "("
	    then
	       typerr = "Name expected."
	       helperror(i)
	    end
	    local n, t = nexttoken(str, i)
	    while n:sub(1, 1) ~= "(" do
	       if n == "." then
		  n, t = nexttoken(str, t)
		  tmp = tmp .. " [\"" .. n .. "\"]"
		  i = t
		  n, t = nexttoken(str, i)
	       else
		  typeerr = "Bad function name."
		  helperror(i)
	       end
	    end
	    if loc then
	       line = strgen(_SPACE, nl) .. tmp .. " ; " .. tmp .. " = function"
	    else
	       line = strgen(_SPACE, nl) .. tmp .. " = function"
	    end
	 end
	 tmp, i = funenv(str, i, line, indent, false)
	 ret = ret .. tmp

      ---------- ARR ----------
      elseif line == "{" then
	 line = strgen(_SPACE, nl) .. line .. " "
	 tmp, i = arrenv(str, i, line, indent, false)
	 ret = ret .. tmp

      ---------- GEN ----------
      else
	 if line == "=" or line == "return" then rval = true end
	 loc = line == "local"
	 ret = ret .. strgen(_SPACE, nl) .. line .. " "
	 nl = 0
      end
      
   end
   if indent > 0 then
      typerr = "Error in scope, expected to reach \"" .. stops[1] .. "\""
      for j = 2, #stops do
	 typerr = typerr .. ", or \"" .. stops[j] .. "\""
      end
      typerr = typerr .. ".\nReached end of file instead."
      helperror(i)
   end
   return ret
end

--------------------------------------------------------------------------------
-- Precompiling
--------------------------------------------------------------------------------
function mem(elem, ...)
   for i, e in pairs{...} do
      if e == elem then
	 return true
      end
   end
   return false
end

function constant(val)
   if tonumber(val) then
      return tonumber(val)
   elseif val:sub(1, 1) == "\"" then
      return val:sub(2, -2)
   elseif val == "nil" then
      return nil
   elseif val == "true" then
      return true
   elseif val == "false" then
      return false
   end
end

function isConstant(val)
   if tonumber(val) then
      return "number"
   elseif val and val:sub(1, 1) == "\"" then
      return "string"
   elseif
      val == "nil" or
      val == "true" or
      val == "false"
   then
      return val
   end
   return false
end

function trysolve(op, arg1, arg2)
   local t, u
   if arg1:sub(1, 1) == "(" then
      arg1 = arg1:sub(2, -2)
   end
   if arg2 and arg2:sub(1, 1) == "(" then
      arg2 = arg2:sub(2, -2)
   end
   if arg2 then
      if op == "*" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    return tostring(u * t)
	 end
      elseif op == "/" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    if tonumber(tostring(u / t)) then
	       return tostring(u / t)
	    end
	 end
      elseif op == "+" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    return tostring(u + t)
	 end
      elseif op == "-" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    return tostring(u - t)
	 end
      elseif op == "^" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    if tonumber(tostring(u ^ t)) then
	       return tostring(u ^ t)
	    end
	 end
      elseif op == "%" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    if tonumber(tostring(u % t)) then
	       return tostring(u % t)
	    end
	 end
      elseif op == ".." then
	 t = isConstant(arg1)
	 u = isConstant(arg2)
	 if t and u and t == "string" and u == "string" then
	    return tostring("\"" .. arg2:sub(2, -2) .. arg1:sub(2, -2) .. "\"")
	 end
      elseif op == "and" then
	 t = isConstant(arg1)
	 u = isConstant(arg2)
	 if t and u then
	    return tostring(constant(arg1) and constant(arg2))
	 elseif u then
	    if constant(arg2) then
	       return arg1
	    else
	       return arg2
	    end
	 end
      elseif op == "or" then
	 t = isConstant(arg1)
	 u = isConstant(arg2)
	 if t and u then
	    return tostring(constant(arg1) or constant(arg2))
	 elseif u then
	    return arg2
	 end
      elseif op == "==" then
	 if arg1 == arg2 then
	    return "true"
	 elseif isConstant(arg1) and isConstant(arg2) then
	    return "false"
	 end
      elseif op == "~=" then
	 if isConstant(arg1) and isConstant(arg2) then
	    if arg1 ~= arg2 then
	       return "true"
	    else
	       return "false"
	    end
	 end
      elseif op == "<" then
	 if isConstant(arg1) and isConstant(arg2) then
	    return tostring(constant(arg1) > constant(arg2))
	 end
      elseif op == ">" then
	 if isConstant(arg1) and isConstant(arg2) then
	    return tostring(constant(arg1) < constant(arg2))
	 end
      elseif op == "<=" then
	 if isConstant(arg1) and isConstant(arg2) then
	    return tostring(constant(arg1) >= constant(arg2))
	 end
      elseif op == ">=" then
	 if isConstant(arg1) and isConstant(arg2) then
	    return tostring(constant(arg1) <= constant(arg2))
	 end
      elseif op == "<<" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    return tostring(u << t)
	 end
      elseif op == ">>" then
	 t = tonumber(arg1)
	 u = tonumber(arg2)
	 if t and u then
	    return tostring(u >> t)
	 end
   end
   else
      if op == "-" then
	 t = tonumber(arg1)
	 if t then
	    return tostring(-t)
	 end
      elseif op == "~" then
	 t = tonumber(arg1)
	 if t then
	    return tostring(~t)
	 end
      elseif op == "not" then
	 if arg1 == "nil" or arg1 == "false" then
	    return "true"
	 elseif arg1 == "true" then
	    return "false"
	 end
      end
   end
   
   return false
end

--------------------------------------------------------------------------------
-- Error handling
--------------------------------------------------------------------------------
function helperror(i)
   if not i or i <= 0 or i >= #comp_code - 1 then
      print("FILE: " .. comp_file .. ".lua")
      print("Line information not available : " .. typerr)
      os.exit()
   end
   local file, text = io.open(comp_file, "r")
   local linum, chnum = 1, 0
   local line, done = "", false
   text = file:read("all")
   file:close()
   
   for j = 1, i do
      if text:sub(j, j) == "\n" then
	 linum = linum + 1
	 chnum = 0
	 line = ""
      else
	 chnum = chnum + 1
	 line = line .. text:sub(j, j)
      end
   end
   while text:sub(i, i) ~= "\n" do
      i = i + 1
      line = line .. text:sub(i, i)
   end
   
   print("FILE: " .. comp_file)
   print("Error at line " .. tostring(linum) .. ": " .. typerr)
   io.write(line)
   print(strgen(" ", chnum - 1) .. "^")
   os.exit()
end

--------------------------------------------------------------------------------
-- Program
--------------------------------------------------------------------------------
comp_code = preprocess(comp_code)

if comp_flags.sub then
   local file
   file = io.open(comp_target .. ".pp.lua", "w+")
   file:write(comp_code)
   file:close()
end










--------------------------------------------------------------------------------

--[[
-- This function removes lua macros '.' and ':'
function removeMacros(array, indent)
   local nex, pre
   local i = 1
   while i < #array do
      if array[i] == "{" then
	 pre = array[i - 1]
	 nex = {}
	 do
	    local j = i + 1
	    while array[j] ~= "]" do
	       nex[#nex + 1] = array[j]
	       j = j + 1
	    end
	 end
	 array[i - 1] = pre .. " [" .. scan(nex, 1, nil, indent) .. "]"
	 -- Removal
	 pre = #array
	 for j = i, #array - #nex - 2 do
	    array[j] = array[j + #nex + 2]
	 end
	 for j = pre - #nex - 1, pre do
	    array[j] = nil
	 end
	 i = i - 1
      elseif array[i] == "(" then
	 
      elseif type(array[i]) == "string" and array[i]:sub(1,2) == "\"" then
	 
      elseif array[i] == "[" then
	 pre = array[i - 1]
	 nex = {}
	 do
	    local j = i + 1
	    while array[j] ~= "]" do
	       nex[#nex + 1] = array[j]
	       j = j + 1
	    end
	 end
	 array[i - 1] = pre .. " [" .. scan(nex, 1, nil, indent) .. "]"
	 -- Removal
	 pre = #array
	 for j = i, #array - #nex - 2 do
	    array[j] = array[j + #nex + 2]
	 end
	 for j = pre - #nex - 1, pre do
	    array[j] = nil
	 end
	 i = i - 1	 
      elseif array[i] == "." then
	 if i == 1 then
	    typerr = "No table to be referenced by \".\"."
	    helperror()
	 end
	 nex = array[i + 1]
	 pre = array[i - 1]
	 if 
	    isDelimiter(pre) or
	    isOperator(pre)  or
	    isReserved(pre)  or
	    isEnv(pre)       or
	    pre == "true"    or
	    pre == "false"
	 then
	    typerr = "\"" .. pre .. "\" is not a valid table name."
	    helperror()
	 end
	 if isDelimiter(nex) or
	    isOperator(nex)  or
	    isReserved(nex)  or
	    isEnv(nex)       or
	    nex == "true"    or
	    nex == "false"  
	 then
	    typerr = "\"" .. nex .. "\" is not a valid table reference."
	    helperror()
	 end
	 -- À SURVEILLER
	 array[i - 1] = pre .. " [\"" .. nex .. "\"]"
	 for j = i, #array - 2 do
	    array[j] = array[j + 2]
	 end
	 array[#array] = nil
	 array[#array] = nil
	 i = i - 1
      elseif array[i] == ":" then
	 if i == 1 then
	    typerr = "No table to be referenced by \":\"."
	    helperror()
	 end
	 nex = array[i + 1]
	 pre = array[i - 1]
	 if 
	    isDelimiter(pre) or
	    isOperator(pre)  or
	    isReserved(pre)  or
	    isEnv(pre)       or
	    pre == "true"    or
	    pre == "false"
	 then
	    typerr = "\"" .. pre .. "\" is not a valid table name."
	    helperror()
	 end
	 if isDelimiter(nex) or
	    isOperator(nex)  or
	    isReserved(nex)  or
	    isEnv(nex)       or
	    nex == "true"    or
	    nex == "false"  
	 then
	    typerr = "\"" .. nex .. "\" is not a valid table reference."
	    helperror()
	 end
	 if array[i + 2] ~= "(" then
	    typerr = "Expected a function call after \"" .. nex .. "\"."
	    helperror()
	 end
	 -- À SURVEILLER
	 array[i - 1] = pre .. " [\"" .. nex .. "\"]"
	 array[i    ] = "("
	 if array[i + 3] == ")" then
	    array[i + 1] = pre
	    for j = i + 2, #array - 1 do
	       array[j] = array[j + 1]
	    end
	    array[#array] = nil
	 else
	    array[i + 1] = pre
	    array[i + 2] = ","
	    i = i + 1
	 end
      end
      i = i + 1
   end
   return array
   end]]
