--------------------------------------------------------------------------------
-- Stack values and count
--------------------------------------------------------------------------------
local ifct, whct, frct, rpct, fnct, doct = 0, 0, 0, 0, 0, 0
local stack, level, size = {}, 0, 0
local globals = {}

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
ops["return"] = "ret"

function isWhitespace(c)
   return c == " " or c == "\t" or c == "\n"
end

function isParenthesized(expr)
   return expr:sub(1, 1) == "("
end

function isBracketed(expr)
   return expr:sub(1, 1) == ")"
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

-- Closure and tail call analysis
function precompile(str, i)
   local ret, tmp = ""
   local expr
   while true do
      expr, i = nextexpr(str, i)
      if not expr then break end

      if expr == "end" then
	 return ret, i

      elseif expr == "else" then
	 return ret, i

      elseif expr == "if" then

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

function compile(str, i)
   local ret, tmp = ""
   local expr

   newlevel()
   
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
   return ret
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
	 return "ref\t" .. tostring(size - stk[var]) .. "\n"
      end
   end
   if not globals[var] then
      globals[var] = true
   end
   return "var\t" .. var .. "\n"
end

function translate(expr)
   if isParenthesized(expr) or isBracketed(expr) then
      return translate(expr:sub(2, #expr - 1))
   end
   local tmp, t = nextexpr(expr, 1)
   local ret, operation = "", ""

   while tmp do
      print(tmp)
      if ops[tmp] then
	 operation = ops[tmp]
      elseif tmp == "," then
	 ret = ret .. operation .. "\ntac\n"
	 operation = ""
      elseif tonumber(tmp) then
	 ret = ret .. "num\t" .. tmp .. "\n"
      elseif tmp == "false" or tmp == "true" then
	 ret = ret .. "bool\t" .. tmp .. "\n"
      elseif tmp:sub(1, 1) == "\"" then
	 ret = ret .. "str\t" .. tmp .. "\n"
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
   return ret .. operation .. "\n"
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
   if expr[1] == "local" and not expr[2] then
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
      expr[c], i = nextexpr(str, i)
   end
   if eq then
      if expr[1] == "local" then
	 for j = 2, #expr do
	    if expr[j] == "=" then
	       c = j + 1
	       ret = "set\t" .. tostring(j - 1) .. "\n"
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
      c = 1
   end
   for j = c, #expr do
      print(expr[j])
      ret = ret .. translate(expr[j]) .. "tac\n"
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
   
   tmp, i, t = compile(str, i)
   if t == "else" then
      ret = ret .. tmp .. "else\t" .. tostring(ifct) .. "\n"
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
   --TODO
   return ret, i
end

function test(t1, t2)
   if t1 ~= t2 then
      print("Error! Was expecting " .. t1 .. ", got " .. t2 .. "\n")
   end
end

local file = io.open(comp_file .. ".pp.lua", "r")
local text = file:read("all")
file:close()
file = io.open(comp_file .. ".lir", "w+")
file:write(compile(text, 1))
file:close()
