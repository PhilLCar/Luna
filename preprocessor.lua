-- Constant
_SPACE = "   "

--------------------------------------------------------------------------------
-- Error managment values
--------------------------------------------------------------------------------
local linum, chnum = 1, 1
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
      str == "-" or
      str == "+" or
      str == "/" or
      str == "*" or
      str == "~" or
      str == "^" or
      str == "." or
      str == ":" or
      str == "<" or
      str == ">" or
      str == "#" or
      str == "%" or
      str == "~" or
      -- 2 char operators
      str == "~=" or
      str == ">=" or
      str == "<=" or
      str == "==" or
      str == ".." or
      str == "or" or
      str == ">>" or
      str == "<<" or
      -- 3 char operators
      str == "and"  or
      str == "not"
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
      chnum = chnum + 1
      if i > #str then
	 return false, i
      end
      s = str:sub(i, i)
   end

   -- ***Special cases*** (3 char)
   s = str:sub(i, i + 2)
   
   if s == "..." or isOperator(s) then
      chnum = chnum + 2
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
      chnum = chnum + 1
      return s, i + 2
   end

   -- ***Special cases*** (1 char)
   s = s:sub(1, 1)

   if s == "\n" then
      linum = linum + 1
      chnum = 1
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
	 chnum = chnum + 1
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
      chnum = chnum + 1
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
   local tl, tc  = linum, chnum
   
   while true do
      tc, tl = chnum, linum
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
	       linum, chnum = tl, tc
	       break
	    else
	       linum, chnum = tl, tc
	       typerr = "Unexpected token \"" .. token .. "\""
	       helperror()
	    end
	 else
	    expr[j] = token
	    last = "op"
	 end
      elseif isDelimiter(token) then
	 if token == "(" then c = c + 1
	 elseif token == ")" then c = c - 1
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
	    linum, chnum = tl, tc
	    break
	 else
	    expr[j] = token
	 end
      else
	 if last == "var" then
	    linum, chnum = tl, tc
	    typerr = "Syntax error, possibly missing an operator?"
	    helperror()
	 end
	 expr[j] = token
	 last = "var"
      end
	 
      i = k
   end

   if c ~= 0 then
      typerr = "Parenthesis mismatch."
      helperror()
   end
   expr = removeMacros(expr)
   ret = scan(expr, 1, nil, indent)
   return ret, i
end

-- Priority parenthesizing function.
function associate(arr, left, unary, indent, ...)
   local ops = {...}
   local start, stop, inc
   local mem, newarr, j = true, {}
   -- Unary operators
   if unary then
      local i = 1
      while i <= #arr do
	 if mem and
	    (arr[i] == "-" or arr[i] == "not" or arr[i] == "~" or arr[i] == "#")
	 then
	    j = 1
	    while arr[i + j] == "\n" do
	       arr[i] = arr[i] .. "\n" .. strgen(_SPACE, indent + 1)
	       j = j + 1
	    end
	    if j > 1 then
	       arr[i + j] = "(" .. arr[i] .. arr[i + j] .. ")"
	    else
	       arr[i + j] = "(" .. arr[i] .. " " .. arr[i + j] .. ")"
	    end
	    for k = i, i + j - 1 do
	       arr[k] = nil
	    end
	    i = i + j
	    mem = false
	 else
	    mem = arr[i]
	    mem = isOperator(mem) or isReserved(mem) or isPunctuation(mem) or mem == "\n"
	 end
	 i = i + 1
      end
   -- Binary operators
   else
      -- Associativity
      if left then
	 start = 2
	 stop = #arr
	 inc = 1
      else
	 start = #arr - 1
	 stop = 1
	 inc = -1
      end
      local i = start
      while (inc == 1 and i < stop) or (inc == -1 and i > stop) do
	 mem = false
	 for k, v in ipairs(ops) do
	    if v == arr[i] then
	       mem = v
	       break
	    end
	 end
	 if mem then
	    j = inc
	    while arr[i + j] == "\n" do
	       mem = mem .. "\n" .. strgen(_SPACE, indent + 1)
	       j = j + inc
	    end
	    if j > inc then
	       arr[i + j] = "(" .. arr[i - inc] .. " " .. mem .. arr[i + j] .. ")"
	    elseif j < inc then
	       arr[i + j] = "(" .. arr[i + j] .. " " .. mem .. arr[i - inc] .. ")"
	    else
	       arr[i + j] = "(" .. arr[i - 1] .. " " .. mem .. " " .. arr[i + 1] .. ")"
	    end
	    for k = i - inc, i + j - inc, inc do
	       arr[k] = nil
	    end
	 end
	 i = i + inc
      end
   end
   j = 0
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
	 elseif array[i] == "(" then
	    ret, i = scan(array, i + 1, ")", indent)
	    if ret:sub(1, 1) ~= "(" then
	       ret = "(" .. ret .. ")"
	    else
	       for k = 1, #ret do
		  if ret:sub(k, k) == "," then
		     ret = "(" .. ret .. ")"
		     break
		  end
	       end
	    end
	    newarr[j] = ret
	    if j > 1 and
	       not isOperator(newarr[j - 1]) and
	       newarr[j - 1] ~= "\n"
	    then
	       -- À SURVEILLER (autrefois entre parenthèse)
	       newarr[j - 1] = newarr[j - 1] .. " " .. newarr[j]
	       newarr[j] = nil
	       j = j - 1
	    end
	 elseif array[i] == "[" then
	    ret, i = scan(array, i + 1, "]", indent)
	    newarr[j] = "[" .. ret .. "]"
	    if j > 1 and
	       not isOperator(newarr[j - 1]) and
	       newarr[j - 1] ~= "\n"
	    then
	       -- À SURVEILLER (autrefois entre parenthèse)
	       newarr[j - 1] = newarr[j - 1] .. " " .. newarr[j]
	       newarr[j] = nil
	       j = j - 1
	    end
	 elseif array[i] == "{" then
	    ret, i = scan(array, i + 1, "}", indent)
	    newarr[j] = "{" .. ret .. "}"
	    if j > 1 and
	       not isOperator(newarr[j - 1]) and
	       newarr[j - 1] ~= "\n"
	    then
	       -- À SURVEILLER (autrefois entre parenthèse)
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
   -- PRIORITY LEVELS --
   -- Level 0 - Bitwise       : 
   newarr = associate(newarr, true, false, indent, "<<", ">>")
   -- Level 1 - Power         : ^               [right-associative]
   newarr = associate(newarr, false, false, indent, "^")
   -- Level 2 - Unary         : ~ - not #       [left-associative ]
   newarr = associate(newarr, true , true , indent)
   -- Level 3 - Multiplicative: * / %           [left-associative ]
   newarr = associate(newarr, true , false, indent, "*", "/", "%")
   -- Level 4 - Additive      : + -             [left-associative ]
   newarr = associate(newarr, true , false, indent, "+", "-")
   -- Level 5 - Concatenation : ..              [right-associative]
   newarr = associate(newarr, false, false, indent, "..")
   -- Level 6 - Boolean       : == ~= <= >= < > [left-associative ]
   newarr = associate(newarr, true , false, indent, "==", "~=", "<=", ">=", "<", ">")
   -- Level 7 - Conjunction   : and             [left-associative ]
   newarr = associate(newarr, true , false, indent, "and")
   -- Level 8 - Disjunction   : or              [left-associative ]
   newarr = associate(newarr, true , false, indent, "or")

   for i, v in ipairs(newarr) do
      if v == "," then v = " , " end
      if v == "\n" then v = v .. strgen(_SPACE, indent + 1) end
      ret = ret .. v
   end
   return ret, i
end

-- This function removes lua macros '.' and ':'
function removeMacros(array)
   local nex, pre
   local i = 1
   while i < #array do
      if array[i] == "." then
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
end

-- Comment parsing
function compar(str, i)
   local s = str:sub(i + 2, i + 3)
   local line = chnum == 1
   chnum = chnum + 2
   if s == "[=" or s == "[[" then
      s, i = nexttoken(str, i + 2)
      s, i = nexttoken(str, i)
   else
      i = i + 3
      repeat
	 i = i + 1
	 chnum = chnum + 1
	 s = str:sub(i, i)
      until i >= #str or s == "\n"
      s, i = nexttoken(str, i)
   end
   if line and s then
      if s ~= "\n" then
	 typerr = "Unexpected symbol " .. s .. "."
	 helperror()
      end
      s, i = nexttoken(str, i)
   end
   return s, i
end

-- String parsing
function strpar(str, i, t)
      local n, ret = 1, "\""
      local ti, tl = i, 0
      chnum = chnum + 1

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
	    helperror()
	    break
	 end
	 s = str:sub(i, i)
	 if s == "\n" then
	    tl = tl + 1
	    ti = i
	    if not t then ret = ret .. "\\n" end
	    ret = ret .. "\n"
	 elseif s == "\t" and not t then
	    ret = ret .. "\\t"
	 elseif s == "\"" and t ~= s then
	    ret = ret .. "\\\""
	 elseif t and s == "\\" then
	    i = i + 1
	    ret = ret .. s .. str:sub(i, i)
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
      
      linum = linum + tl
      chnum = i - ti
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
      helperror()
   end
   ret = ret .. tmp .. " "
   tmp, i, line = _preprocess(str, i, indent + 1, { "else", "end" })
   ret = ret .. tmp .. line .. " "
   if line:sub(#line - 3, #line) == "else" then
      tmp, i, line = _preprocess(str, i, indent + 1, { "end" })
      ret = ret .. tmp .. line .. " "
   end
   if elif then
      linum = linum - 1
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
   if line:sub(#line - 1, #line) == "in" then
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
      helperror()
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
      helperror()
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
   local tl, tc = linum, chnum
   local nl, rval = 0, false -- strgen("  ", indent)
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
	 helperror()
      elseif line == "}" then
	 typerr = "Closing non-existant table declaration."
	 helperror()
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
	       helperror()
	    end
	    line = strgen(_SPACE, nl) .. tmp .. " = function"
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
      linum, chnum = tl, tc
      helperror()
   end
   return ret
end

--------------------------------------------------------------------------------
-- Error handling
--------------------------------------------------------------------------------
function helperror()
   local file, text = io.open(comp_file .. ".lua", "r")
   for i = 1, linum do
      text = file:read("line")
   end
   file:close()
   print("FILE: " .. comp_file .. ".lua")
   print("Error at line " .. tostring(linum) .. ": " .. typerr)
   print(text)
   for i = 1, chnum do
      io.write(" ")
   end
   print("^")
   os.exit()
end

--------------------------------------------------------------------------------
-- Program
--------------------------------------------------------------------------------
local file = io.open(comp_file .. ".lua", "r")
local text = file:read("all")
file:close()
file = io.open(comp_file .. ".pp.lua", "w+")
file:write(preprocess(text))
file:close()
