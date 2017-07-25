--------------------------------------------------------------------------------
-- Stack values and count
--------------------------------------------------------------------------------
local ifct, whct, frct, rpct, fnct, doct = 0, 0, 0, 0, 0, 0
local stack, level, size = {}, 0, 0
local globals = {}
local functions = "\n"

ops = {}
ops["+"]      = "add"
ops["-"]      = "sub"
ops["%"]      = "mod"
ops["--"]     = "neg"
ops["*"]      = "mul"
ops["/"]      = "div"
ops["^"]      = "exp"
ops[".."]     = "con"
ops[">"]      = "gt"
ops["<"]      = "lt"
ops[">="]     = "gte"
ops["<="]     = "lte"
ops["=="]     = "eq"
ops["~="]     = "neq"
ops["and"]    = "and"
ops["or"]     = "or"
ops["not"]    = "not"
ops["~"]      = "inv"
ops["#"]      = "len"
ops["nil"]    = "nil"

function isWhitespace(c)
   return c == " " or c == "\t" or c == "\n"
end

function isParenthesized(expr)
   return expr:sub(1, 1) == "(" and expr:sub(#expr, #expr) == ")"
end

function isBracketed(expr)
   return expr:sub(1, 1) == ")" and expr:sub(#expr, #expr) == "]"
end

function nextexpr(str, i)
   local c, ret = 0, ""
   local s   = 0
   local smode, escape = false
   while true do
      if i > #str then
	 if ret == "" then return false, i
	 else return ret, i
	 end
      end
      s = str:sub(i, i)
      if not isWhitespace(s) or c > 0 then
	 ret = ret .. s
	 if s == "\"" and not escape then
	    smode = not smode
	 elseif smode and s == "\\" then
	    escape = true
	 elseif not smode and (s == "(" or s == "[") then
	    c = c + 1
	 elseif not smode and (s == ")" or s == "]") then
	    c = c - 1
	 elseif smode then
	    escape = false
	 end
      elseif ret ~= "" and c == 0 and not smode then
	 break
      end
      i = i + 1
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
	 ret = ret .. poplevel()
	 return ret, i, "end"

      elseif expr == "else" then
	 ret = ret .. poplevel()
	 return ret, i, "else"

      elseif expr == "if" then
	 tmp, i = ifscope(str, i)
	 ret = ret .. tmp

      elseif expr == "do" then
	 tmp, i = doscope(str, i)
	 ret = ret .. tmp

      elseif expr == "for" then
	 tmp, i = forscope(str, i)
	 ret = ret .. tmp

      elseif expr == "while" then
	 tmp, i = whilescope(str, i)
	 ret = ret .. tmp

      elseif expr == "repeat" then
	 tmp, i = repscope(str, i)
	 ret = ret .. tmp

	 -- unlikely and useless entry
      elseif expr == "function" then
	 tmp, i = funscope(str, i)
	 ret = ret .. tmp

      elseif expr == "{" then
	 tmp, i = arrscope(str, i)
	 ret = ret .. tmp

      else
	 tmp, i = evaluate(str, i, expr)
	 ret = ret .. tmp
      end
   end
   
   ret = ret .. poplevel()
   return ret .. "exit\n" .. functions
end

function newlevel()
   level = level + 1
   stack[level] = {}
   stack[level]["size"] = size
end

function poplevel()
   local free = tostring(stack[level]["size"])
   size = stack[level]["size"]
   stack[level] = nil
   level = level - 1
   return "free\t" .. free .. "\n"
end

function register(loc, var)
   local ret = ""
   if loc then
      stack[level][var] = size
      size = size + 1
   else
      globals[var] = true
   end
end

function access(var)
   for lvl, stk in ipairs(stack) do
      if stk[var] then
	 return "ref\t" .. tostring(size - stk[var] - 1) .. "\n"
      end
   end
   if not globals[var] then
      globals[var] = true
   end
   return "var\t" .. var .. "\n"
end

function translate(expr)
   local tmp, t = nextexpr(expr, 1)
   local ret, operation = "", ""

   while tmp do
      if ops[tmp] then
	 operation = ops[tmp]
	 tmp, t = nextexpr(expr, t)
      else
	 if tmp == "," then
	    ret = ret .. operation .. "tac\n"
	    operation = ""
	 elseif tonumber(tmp) then
	    ret = ret .. "num\t" .. tmp .. "\n"
	 elseif tmp == "false" or tmp == "true" then
	    ret = ret .. "bool\t" .. tmp .. "\n"
	 elseif tmp:sub(1, 1) == "\"" then
	    ret = ret .. "str\t" .. tmp .. "\n"
	 elseif isParenthesized(tmp) or isBracketed(tmp) then
	    ret = ret .. translate(tmp:sub(2, #tmp - 1))
	 else
	    ret = ret .. access(tmp)
	 end
	 
	 tmp, t = nextexpr(expr, t)
	 
	 while tmp and isBracketed(tmp) do
	    ret = ret .. translate(tmp) .. "index\n"
	    tmp, t = nextexpr(expr, t)
	 end
	 if tmp and isParenthesized(tmp) then
	    ret = ret .. "params\n" .. translate(tmp) .. "call\n"
	    tmp, t = nextexpr(expr, t)
	 end
      end
   end
   ret = ret .. operation
   if ret:sub(#ret, #ret) == "\n" then return ret
   else return ret .. "\n"
   end
end

function evaluate(str, i, ...)
   local expr = {...}
   local c, t = #expr
   local eq, tmp = false
   local ret = ""
   if not expr[1] then
      c = 1
      expr[c], i = nextexpr(str, i)
   end
   if (expr[1] == "local" or expr[1] == "return") and not expr[2] then
      c = 2
      expr[c], i = nextexpr(str, i)
   end
   while true do
      tmp, t = nextexpr(str, i)
      if tmp == "=" then
	 eq = true
	 c = c + 1
	 expr[c] = "="
      elseif tmp ~= "," then break end
      i = t
      c = c + 1
      tmp, i = nextexpr(str, i)
      if tmp == "function" then
	 tmp, i = funscope(str, i)
	 functions = functions .. tmp .. "\n"
	 expr[c] = fnct
      else
	 expr[c] = tmp
      end
   end
   if eq then
      if expr[1] == "local" then
	 for j = 2, #expr do
	    if expr[j] == "=" then
	       c = j + 1
	       ret = "set\t" .. tostring(j - 2) .. "\n"
	       break
	    else
	       register(true, expr[j])
	    end
	 end
      else
	 for j = 1, #expr do
	    if expr[j] == "=" then
	       c = j + 1
	       ret = "mod\t" .. tostring(j - 1) .. "\n" .. ret .. "place\n"
	       break
	    else
	       ret = ret .. access(expr[j])
	    end
	 end
      end
   else
      if expr[1] == "return" then
	 c = 2
      else
	 c = 1
      end
   end
   for j = c, #expr do
      if type(expr[j]) == "number" then
	 ret = ret .. "rfct\t" .. tostring(expr[j]) .. "\n"
      else
	 ret = ret .. translate(expr[j])
      end
      if j ~= #expr or eq then ret = ret .. "tac\n" end
   end
   if expr[1] == "return" then
      ret = ret .. "ret\n"
   end
   return ret, i
end

function ifscope(str, i)
   local ret, tmp, t
   ifct = ifct + 1
   ret = "if\t" .. tostring(ifct) .. "\n"

   tmp, i = evaluate(str, i)
   ret = ret .. tmp

   tmp, i = nextexpr(str, i)
   test(tmp, "then")
   ret = ret .. "then\t" .. tostring(ifct) .. "\n"

   newlevel()
   tmp, i, t = compile(str, i)
   if t == "else" then
      ret = ret .. tmp .. "else\t" .. tostring(ifct) .. "\n"
      newlevel()
      tmp, i, t = compile(str, i)
   end
   test(t, "end")
   ret = ret .. tmp .. "iend\t" .. tostring(ifct) .. "\n"
   return ret, i
end

function doscope(str, i)
   local ret, tmp, t
   doct = doct + 1
   ret = "do\t" .. tostring(doct) .. "\n"
   
   tmp, i, t = compile(str, i)
   test(t, "end")
   ret = ret .. tmp .. "dend\t" .. tostring(doct) .. "\n"
   return ret, i
end

function whilescope(str, i)
   local ret, tmp, t
   whct = whct + 1
   ret = "while\t" .. tostring(whct) .. "\n"

   tmp, i = evaluate(str, i)
   ret = ret .. tmp

   tmp, i = nextexpr(str, i)
   test(tmp, "do")
   ret = ret .. "wdo\t" .. tostring(whct) .. "\n"
   
   tmp, i, t = compile(str, i)
   test(t, "end")
   ret = ret .. tmp .. "wend\t" .. tostring(whct) .. "\n"
   return ret, i
end

function forscope(str, i)
   -- TODO
   return ret, i
end

function repscope(str, i)
   local ret, tmp, t
   rpct = rpct + 1
   ret = "repeat\t" .. tostring(rpct) .. "\n"
 
   tmp, i, t = compile(str, i)
   test(t, "until")
   ret = ret .. tmp .. "until\t" .. tostring(rpct) .. "\n"

   tmp, i = evaluate(str, i)
   ret = ret .. tmp .. "rend\t" .. tostring(rpct) .. "\n"
   return ret, i
end

function arrscope(str, i)
   --TODO
   return ret, i
end

function funscope(str, i)
   local par, tmp = true
   local t, ret   = 1
   
   fnct = fnct + 1
   ret = "fct\t" .. tostring(fnct) .. "\n"
   
   tmp, i = nextexpr(str, i)
   tmp = tmp:sub(2, #tmp - 1)
   
   newlevel()
   while par do
      par, t = nextexpr(tmp, t)
      if not par then break end
      register(true, par)
      par, t = nextexpr(tmp, t)
   end
   tmp, i, t = compile(str, i)
   test(t, "end")
   ret = ret .. tmp .. "fend\t" .. tostring(fnct) .. "\n"
   return ret, i
end

function test(t1, t2)
   if t1 ~= t2 then
      print("Error! Was expecting '" .. tostring(t1) .. "', got '" .. tostring(t2) .. "'.\n")
   end
end

newlevel()
local file = io.open(comp_file .. ".pp.lua", "r")
local text = file:read("all")
file:close()
file = io.open(comp_file .. ".lir", "w+")
file:write(compile(text, 1))
file:close()
