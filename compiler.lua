--------------------------------------------------------------------------------
-- Stack values and count
--------------------------------------------------------------------------------
local ifct, whct, frct, fict, rpct, fnct, doct = 0, 0, 0, 0, 0, 0, 0
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

function isWhitespace(c)
   return c == " " or c == "\t" or c == "\n"
end

function isParenthesized(expr)
   return expr:sub(1, 1) == "(" and expr:sub(#expr, #expr) == ")"
end

function isBracketed(expr)
   return expr:sub(1, 1) == "[" and expr:sub(#expr, #expr) == "]"
end

function isAccoladed(expr)
   return expr:sub(1, 1) == "{" and expr:sub(#expr, #expr) == "}"
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
      if not isWhitespace(s) or c > 0 or (smode and s == " ") then
	 ret = ret .. s
	 if s == "\"" and not escape then
	    smode = not smode
	 elseif smode and not escape and s == "\\" then
	    escape = true
	 elseif not smode and (s == "(" or s == "[" or s == "{") then
	    c = c + 1
	 elseif not smode and (s == ")" or s == "]" or s == "}") then
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

function compile(str, i, fname, flvl)
   local ret, tmp = ""
   local expr
   
   while true do
      expr, i = nextexpr(str, i)
      if not expr then break end

      if expr == "end" then
	 local tmp = stack[level]["clo"]
	 ret = ret .. poplevel()
	 return ret, i, expr, tmp

      elseif expr == "else" then
	 ret = ret .. poplevel()
	 return ret, i, expr

      elseif expr == "until" then
	 tmp, i = evaluate(str, i, fname, flvl)
	 ret = ret .. tmp .. poplevel()
	 return ret, i, expr

      elseif expr == "if" then
	 tmp, i = ifscope(str, i, fname, flvl)
	 ret = ret .. tmp

      elseif expr == "do" then
	 tmp, i = doscope(str, i, fname, flvl)
	 ret = ret .. tmp

      elseif expr == "for" then
	 tmp, i = forscope(str, i, fname, flvl)
	 ret = ret .. tmp

      elseif expr == "while" then
	 tmp, i = whilescope(str, i, fname, flvl)
	 ret = ret .. tmp

      elseif expr == "repeat" then
	 tmp, i = repscope(str, i, fname, flvl)
	 ret = ret .. tmp

	 -- unlikely and useless entry
      elseif expr == "function" then
	 tmp, i = funscope(str, i)
	 ret = ret .. tmp

      else
	 tmp, i = evaluate(str, i, fname, flvl, expr)
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
   stack[level]["clo"] = {}
end

function poplevel()
   local free = tostring(size - stack[level]["size"])
   size = stack[level]["size"]
   stack[level] = nil
   level = level - 1
   return "free\t" .. free .. "\n"
end

function register(loc, var)
   local ret = ""
   if loc then
      if var then
	 stack[level][var] = size
      end
      size = size + 1
   else
      globals[var] = true
   end
end

function access(var, flvl, def)
   local stk
   for i = level, 1, -1 do
      stk = stack[i]
      if stk.clo[var] then
	 return "clo\t" .. var .. "\n"
      end
      if stk[var] then
	 if i < flvl then
	    local clo = stack[level]["clo"]
	    clo[var] = true
	    return "clo\t" .. var .. "\n"
	 end
	 return "ref\t" .. tostring(stk[var]) .. "\n"
      end
   end
   if def or globals[var] then
      globals[var] = true
      return "gbl\t" .. var .. "\n"
   end
   return "var\t" .. var .. "\n"
end

function translate(expr, fname, flvl, def)
   local tmp, t = nextexpr(expr, 1)
   local ret, operation = "", ""
   local cnt = 1
   local trans, nval
   
   while tmp do
      if ops[tmp] then
	 operation = ops[tmp]
	 tmp, t = nextexpr(expr, t)
      else
	 if tmp == "," then
	    cnt = cnt + 1
	    ret = ret .. operation .. "tac\n"
	    operation = ""
	    tmp, t = nextexpr(expr, t)
	 end
	 if tonumber(tmp) then
	    ret = ret .. "num\t" .. tmp .. "\n"
	 elseif tmp == "false" or tmp == "true" or tmp == "nil" then
	    ret = ret .. "spec\t" .. tmp .. "\n"
	 elseif tmp:sub(1, 1) == "\"" then
	    ret = ret .. "str\t" .. tmp .. "\n"
	 elseif isParenthesized(tmp) or isBracketed(tmp) then
	    ret = ret .. translate(tmp:sub(2, #tmp - 1), fname, flvl, false)
	 elseif isAccoladed(tmp) then
	    trans, nval = translate(tmp:sub(2, #tmp - 1), fname, flvl, false)
	    ret = ret .. "init\t" .. nval .. "\n" ..
	       trans .. "tac\ndone\n"	 
	 else
	    if tmp == "break" then
	       ret = ret .. "brk\n"
	    else
	       ret = ret .. access(tmp, flvl, def)
	    end
	 end
	 
	 tmp, t = nextexpr(expr, t)
	 
	 while tmp and (isBracketed(tmp) or isParenthesized(tmp) or isAccoladed(tmp)) do
	    if isParenthesized(tmp) or isAccoladed(tmp) then
	       if isParenthesized(tmp) then
		  trans, nval = translate(tmp:sub(2, #tmp - 1), fname, flvl, false)
	       else
		  trans, nval = translate(tmp, fname, flvl, false)
	       end
	       if fname then
		  ret = ret .. "params\t" .. nval .. "\n" ..
		     trans .. "tac\ntcall\n"
	       else
		  ret = ret .. "params\t" .. nval .. "\n" ..
		     trans .. "tac\ncall\n"
	       end
	    else
	       ret = ret .. translate(tmp, fname, flvl, false) .. "index\n"
	    end
	       tmp, t = nextexpr(expr, t)
	 end
      end
   end
   ret = ret .. operation
   if ret:sub(#ret, #ret) == "\n" then return ret, cnt
   elseif ret == "" then return ret, 0
   else return ret .. "\n", cnt
   end
end

function evaluate(str, i, fname, flvl, ...)
   local expr = {...}
   local c, t = 1
   local eq,  tmp = false, expr[1]
   local ret, typ = "", 0
   expr["code"] = {}
   -- Line parsing preparation
   if not tmp then
      tmp, i = nextexpr(str, i)
   end
   if tmp == "local" then
      typ = 1
      tmp, i = nextexpr(str, i)
   elseif tmp == "return" then
      typ = 2
      tmp, i = nextexpr(str, i)
   end
   -- Line parsing
   while true do
      -- The function scope is most of the time within a assignment
      -- This makes sure it can be accessed properly
      if tmp == "function" then
	 if eq then
	    tmp, i, expr[c], expr["code"][c] = funscope(str, i, expr[c - eq])
	 else
	    tmp, i, expr[c], encl["code"][c] = funscope(str, i)
	 end
	 functions = functions .. tmp .. "\n"
	 tmp, t = nextexpr(str, i)
      else
	 expr[c] = tmp
	 tmp, t = nextexpr(str, i)
	 while tmp and (isBracketed(tmp) or isParenthesized(tmp)) do
	    expr[c] = expr[c] .. " " .. tmp
	    i = t
	    tmp, t = nextexpr(str, t)
	 end
      end
      -- Should be an equal or comma
      if tmp == "=" then
	 eq = c
      elseif tmp ~= "," then break end
      -- The t is to make sure the i isn't increased over the expression limit
      i = t
      c = c + 1
      tmp, i = nextexpr(str, i)
   end
   if not eq then
      if typ ~= 1 then
	 eq = 0
      else
	 eq = c
	 c = eq + eq
      end
   else
      c = eq + eq
   end
   -- global
   if typ == 0 then
      ret = "chg\t" .. tostring(eq) .. "\n"
      fname = nil
   -- local
   elseif typ == 1 then
      ret = "set\t" .. tostring(eq) .. "\n"
      fname = nil
   -- return
   elseif typ == 2 then
      ret = "ret\t" .. tostring(c) .. "\n"
      if c > 1 then fname = nil end
   end
   tmp = ""
   for j = eq + 1, c do -- sets the right-hand side to right number of calls
      -- Checks for function declarations
      if j == #expr and j ~= c then
	 tmp = tmp .. "struct\n"
      end
      if j > #expr then
	 tmp = tmp .. "spec\tnil\n"
      elseif type(expr[j]) == "number" then
	 tmp = tmp .. expr["code"][j]
      else
	 tmp = tmp .. translate(expr[j], fname, flvl, false)
      end
      tmp = tmp .. "tac\n"
   end
   for j = 1, eq do
      if typ == 0 then
	 ret = ret .. translate(expr[j], fname, flvl, true) .. "tac\n"
      elseif typ == 1 then
	 register(true, expr[j])
      end
   end
   if typ == 0 then ret = ret .. "place\n" end
   return ret .. tmp .. "stack\n", i
end

function ifscope(str, i, fname, flvl)
   local ret, tmp, t
   local ifct = ifct
   ifct = ifct + 1
   ret = "if\t" .. tostring(ifct) .. "\n"

   tmp, i = evaluate(str, i, fname, flvl)
   ret = ret .. tmp

   tmp, i = nextexpr(str, i)
   test("then", tmp)
   ret = ret .. "then\t" .. tostring(ifct) .. "\n"

   newlevel()
   tmp, i, t = compile(str, i, fname, flvl)
   if t == "else" then
      ret = ret .. tmp .. "else\t" .. tostring(ifct) .. "\n"
      newlevel()
      tmp, i, t = compile(str, i, fname, flvl)
   end
   test("end", t)
   ret = ret .. tmp .. "iend\t" .. tostring(ifct) .. "\n"
   return ret, i
end

function doscope(str, i, fname, flvl)
   local ret, tmp, t
   local doct = doct
   doct = doct + 1
   ret = "do\t" .. tostring(doct) .. "\n"
   newlevel()
   tmp, i, t = compile(str, i, fname, flvl)
   test("end", t)
   ret = ret .. tmp .. "dend\t" .. tostring(doct) .. "\n"
   return ret, i
end

function whilescope(str, i, fname, flvl)
   local ret, tmp, t
   local whct = whct
   whct = whct + 1
   ret = "while\t" .. tostring(whct) .. "\n"

   tmp, i = evaluate(str, i, fname, flvl)
   ret = ret .. tmp

   tmp, i = nextexpr(str, i)
   test("do", tmp)
   ret = ret .. "wdo\t" .. tostring(whct) .. "\n"

   newlevel()
   tmp, i, t = compile(str, i, fname, flvl)
   test("end", t)
   ret = ret .. tmp .. "wend\t" .. tostring(whct) .. "\n"
   return ret, i
end

function forscope(str, i, fname, flvl)
   local ret, t, tmp = "", 0
   local fp, c = {}, 0
   local forin = false
   local fict, frct = fict, frct
   while true do
      tmp, i = nextexpr(str, i)
      if tmp == "in" then
	 forin = true
      elseif tmp == "," then
	 t = t + 1
      end
      if tmp == "do" then break end
      c = c + 1
      fp[c] = tmp
   end
   newlevel()
   if forin then
      fict = fict + 1
      ret = "fin\t" .. tostring(fict) .. "\n" ..
	 "iter\t" .. tostring(t + 1) .. "\n"
      c = 1
      while fp[c] ~= "in" do
	 if fp[c] ~= "," then
	    register(true, fp[c])
	 end
	 c = c + 1
      end
      tmp = ""
      c = c + 1
      while fp[c] do
	 tmp = tmp .. fp[c] .. " "
	 c = c + 1
      end
      ret = ret .. translate(tmp, fname, flvl, false) .. "fido\t" .. tostring(fict) .. "\n"
   else
      if t ~= 1 and t ~= 2 then
	 print("ERR") --temporaire
	 print(t)
      end
      frct = frct + 1
      ret = "for\t" .. tostring(frct) .. "\n" ..
	 "iter\t3\n"
      register(true, fp[1])
      register(true, nil)
      register(true, nil)
      test("=", fp[2])
      c = 3
      tmp = ""
      while fp[c] do
	 tmp = tmp .. fp[c] .. " "
	 c = c + 1
      end
      if t == 1 then tmp = tmp .. ", 1" end
      ret = ret .. translate(tmp, fname, flvl, false) .. "frdo\t" .. tostring(frct) .. "\n"
   end
   newlevel()
   tmp, i, t = compile(str, i, fname, flvl)
   test("end", t)
   poplevel()
   if forin then
      ret = ret .. tmp .. "fiend\t" .. tostring(fict) .. "\n"
   else
      ret = ret .. tmp .. "frend\t" .. tostring(frct) .. "\n"
   end
   return ret, i
end

function repscope(str, i, fname, flvl)
   local ret, tmp, t
   local rpct = rpct
   rpct = rpct + 1
   ret = "repeat\t" .. tostring(rpct) .. "\n"

   newlevel()
   tmp, i, t = compile(str, i, fname, flvl)
   test("until", t)
   ret = ret .. tmp .. "rend\t" .. tostring(rpct) .. "\n"
   return ret, i
end

function funscope(str, i, ...)
   local par, tmp = true
   local t, ret   = 1
   local fnct = fnct
   local fname, clo = {...}
   local narg, s = 0, false
   local sz = size
   fname = fname[1]
   
   
   fnct = fnct + 1
   ret = "fct\t" .. tostring(fnct) .. "\n"
   if fname then
      ret = ret .. "fname\t" .. fname .. "\n"
   end
   
   tmp, i = nextexpr(str, i)
   tmp = tmp:sub(2, #tmp - 1)

   size = 0
   newlevel()
   while par do
      par, t = nextexpr(tmp, t)
      if not par then break end
      -- temproraire
      if s then print("ERR2") end
      narg = narg + 1
      register(true, par)
      if par == "..." then s = true end
      par, t = nextexpr(tmp, t)
   end
   if s then
      ret = ret .. "nargs\t" .. tostring(narg) .. "\n"
   else
      ret = ret .. "narg\t" .. tostring(narg) .. "\n"
   end
   tmp, i, t, clo = compile(str, i, fname, level)
   test("end", t)
   ret = ret .. tmp .. "fend\t" .. tostring(fnct) .. "\n"
   size = sz
   
   tmp = ""
   t = 0
   for name in pairs(clo) do
      t = t + 1
      tmp = translate(name, fname, 0, false) .. "encl\t\"" .. name .. "\"\n" .. tmp
   end
   tmp = tmp .. "rfct\t" .. fnct .. "\n"
   if t > 0 then
      tmp = tmp .. "open\t" .. tostring(t) .. "\n"
   end
   return ret, i, fnct, tmp
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
file:write(compile(text, 1, nil, level))
file:close()
