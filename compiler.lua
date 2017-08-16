--------------------------------------------------------------------------------
-- Stack values and count
--------------------------------------------------------------------------------
local ifct, whct, frct, rpct, fnct, doct, mrct = 0, 0, 0, 0, 0, 0, 0
local stack, level, size = {}, 0, 0
local functions = "\n"
local _CLO = "__CLO__"
local _SIZE = "__SIZE__"
local globals = {}
local prelibs = {}
libs = {}

ops = {}
ops["+"]      = "add"
ops["-"]      = "sub"
ops["%"]      = "mod"
ops["*"]      = "mul"
ops["/"]      = "div"
ops["^"]      = "pow"
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
ops["<<"]     = "bsal"
ops[">>"]     = "bsar"
ops["|"]      = "bor"
ops["&"]      = "band"
ops["^^"]     = "bxor"
ops["~"]      = "bxor"
ops["==="]    = "beq"
ops["!="]     = "bneq"
ops[">>>"]    = "bshr"
ops["\\"]     = "idiv"
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

function isString(expr)
   return expr:sub(1, 1) == "\"" and expr:sub(#expr, #expr) == "\""
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
	 local tmp = stack[level][_CLO]
	 ret = ret .. poplevel()
	 for i, v in pairs(tmp) do
	    if v == 0 then
	       tmp[i] = nil
	    end
	 end
	 return ret, i, expr, tmp

      elseif expr == "else" then
	 ret = ret .. poplevel()
	 return ret, i, expr

      elseif expr == "until" then
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
   stack[level][_SIZE] = size
   stack[level][_CLO] = {}
end

function poplevel()
   local free = tostring(size - stack[level][_SIZE])
   size = stack[level][_SIZE]
   stack[level] = nil
   level = level - 1
   return "free\t" .. free .. "\n"
end

function register(loc, var)
   local ret = ""
   if loc then
      if var then
	 stack[level][var] = size 
	 size = size + 1
      else
	 size = size + 1
      end
   else
      globals[var] = true
   end
end

function access(var, flvl, def)
   local stk
   for i = level, 1, -1 do
      stk = stack[i]
      if stk[_CLO][var] then
	 return "clo\t" .. var .. "\n"
      end
      if stk[var] then
	 if i < flvl then
	    local clo = stack[flvl][_CLO]
	    clo[var] = true
	    return "clo\t" .. var .. "\n"
	 end
	 if var == "..." then
	    return "arg\t" .. tostring(stk[var]) .. "\n"
	 else
	    return "ref\t" .. tostring(stk[var]) .. "\n"
	 end
      end
   end
   if def or globals[var] then
      globals[var] = true
      return "gbl\t" .. var .. "\n"
   end
   for g, v in pairs(prelibs) do
      if v[var] then
	 libs[g] = true
	 return "gbl\t" .. var .. "\n"
      end
   end
   return "var\t" .. var .. "\n"
end

function translate(expr, fname, flvl, def)
   local tmp, t = nextexpr(expr, 1)
   local steps, ret = {}, ""
   local op1, op2, op
   local func = true
   local trunc, f

   local function nextop(str, append)
      if append then
	 if op2 then op2 = op2 .. str
	 else op1 = op1 .. str end
      else
	 if op1 then op2 = str
	 else op1 = str end
      end
   end
   
   while tmp do
      if ops[tmp] then
	 if tmp == "-" and not op1 then
	    op = "neg\n"
	 elseif tmp == "~" and not op1 then
	    op = "binv\n"
	 else
	    op = ops[tmp] .. "\n"
	 end
	 tmp, t = nextexpr(expr, t)
      else
	 if tmp == "," then
	    if not op2 then op2 = "" end
	    if not op then op = "" end
	    steps[#steps + 1] = { op, op1, op2 }
	    op1, op2, op = nil, nil, nil
	    trunc = false
	    tmp, t = nextexpr(expr, t)
	 end
	 if tmp == ":" then
	    tmp, t = nextexpr(expr, t)
	    nextop("str\t\"" .. tmp .. "\"\n" .. "findex\n", true)
	    f = true
	 elseif tonumber(tmp) then
	    nextop("num\t" .. tmp .. "\n")
	 elseif tmp == "false" or tmp == "true" or tmp == "nil" then
	    nextop("spec\t" .. tmp .. "\n")
	 elseif tmp:sub(1, 1) == "\"" then
	    nextop("str\t" .. tmp .. "\n")
	 elseif isParenthesized(tmp) or isBracketed(tmp) then
	    nextop((translate(tmp:sub(2, -2), fname, flvl, false)))
	    trunc = isParenthesized(tmp)
	 elseif isAccoladed(tmp) then
	    nextop(arrscope(tmp:sub(2, -2), flvl))	 
	 else
	    if tmp == "break" then
	       ret = ret .. "brk\n"
	    else
	       nextop(access(tmp, flvl, def))
	       func = tmp
	    end
	 end
	 
	 tmp, t = nextexpr(expr, t)
	 
	 while tmp and
	 (isBracketed(tmp) or isParenthesized(tmp) or isAccoladed(tmp) or isString(tmp)) do
	    if isBracketed(tmp) then
	       nextop(translate(tmp, fname, flvl, false) .. "index\n", true)
	    else
	       local trans, nval
	       if isParenthesized(tmp) then
		  trans, nval = translate(tmp:sub(2, -2), fname, flvl, false)
	       else
		  trans, nval = translate(tmp, fname, flvl, false)
	       end
	       if nval > 0 then trans = trans .. "tac\n" end
	       if fname == func then
		  nextop("params\t" .. nval .. "\n" .. trans .. "tcall\n", true)
	       elseif f then
		  nextop("fparams\t" .. nval .. "\n" .. trans .. "call\n", true)
	       else
		  nextop("params\t" .. nval .. "\n" .. trans .. "call\n", true)
	       end
	    end
	    tmp, t = nextexpr(expr, t)
	 end
	 fname = nil
	 f = false
      end
   end
   if op1 then
      if not op2 then op2 = "" end
      if not op then op = "" end
      steps[#steps + 1] = { op, op1, op2 }
   end

   for i, v in ipairs(steps) do
      op, op1, op2 = unpack(v)
      if op == "and\n" or op == "or\n" then
	 mrct = mrct + 1
	 ret = ret .. op:sub(1, -2) .. "\t" .. mrct .. "\n" ..
	    op1 .. "tac\n" .. op2 .. "done\n"
      else
	 ret = ret .. op1 .. op2 .. op
      end
      if i ~= #steps then
	 ret = ret .. "tac\n"
      end
   end
   
   if trunc then
      ret = ret .. "trunc\n"
   end
   if ret:sub(-1, -1) == "\n" then return ret, #steps
   elseif ret == "" then return ret, #steps
   else return ret .. "\n", #steps
   end
end

function evaluate(str, i, fname, flvl, ...)
   local expr = {...}
   local c, t = 1
   local eq,  tmp = false, expr[1]
   local ret, typ = "", 0
   local encl = ""
   expr["code"] = {}
   -- Line parsing preparation
   if not tmp then
      tmp, i = nextexpr(str, i)
   end
   if tmp == "break" then
      return "brk\n", i
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
	 local en
	 if eq then
	    local n, a = getfname(expr[c - eq])
	    if a and typ == 0 then
	       register(false, n)
	    end
	    tmp, i, expr[c], expr["code"][c], en = funscope(str, i, n)
	 else
	    tmp, i, expr[c], expr["code"][c], en = funscope(str, i)
	 end
	 encl = encl .. en
	 functions = functions .. tmp .. "\n"
	 tmp, t = nextexpr(str, i)
      else
	 expr[c] = tmp
	 tmp, t = nextexpr(str, i)
	 while tmp and
	    (isBracketed(tmp) or isParenthesized(tmp) or isAccoladed(tmp) or isString(tmp)) or
	    tmp == ":"
	 do
	    if tmp == ":" then
	       tmp, t = nextexpr(str, t)
	       expr[c] = expr[c] .. " : " .. tmp
	    else
	       expr[c] = expr[c] .. " " .. tmp
	       i = t
	    end
	    tmp, t = nextexpr(str, t)
	 end
	 if tmp == ";" then
	    i = t
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
   return encl .. ret .. tmp .. "stack\n", i
end

function trim(code)
   local tmp = "chg\t0\nplace\n"
   test(tmp, code:sub(1, #tmp))
   code = code:sub(#tmp + 1, #code)
   tmp = "tac\nstack\n"
   test(tmp, code:sub(#code - #tmp + 1, #code))
   code = code:sub(1, #code - #tmp)
   return code
end

function ifscope(str, i, fname, flvl)
   ifct = ifct + 1
   
   local ret, tmp, t
   local ifct = ifct
   
   ret = "if\t" .. tostring(ifct) .. "\n"

   tmp, i = evaluate(str, i, fname, flvl)
   tmp = trim(tmp)
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
   doct = doct + 1
   
   local ret, tmp, t
   local doct = doct
   
   ret = "do\t" .. tostring(doct) .. "\n"
   newlevel()
   tmp, i, t = compile(str, i, fname, flvl)
   test("end", t)
   ret = ret .. tmp .. "dend\t" .. tostring(doct) .. "\n"
   return ret, i
end

function whilescope(str, i, fname, flvl)
   whct = whct + 1
   
   local ret, tmp, t
   local whct = whct
   
   ret = "while\t" .. tostring(whct) .. "\n"

   tmp, i = evaluate(str, i, fname, flvl)
   tmp = trim(tmp)
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
   frct = frct + 1
   
   local ret, t, tmp = "", 0
   local fp, c = {}, 0
   local forin = false
   local frct = frct
   tmp, i = nextexpr(str, i)
   while tmp do
      if tmp == "in" then
	 forin = true
	 c = #fp + 1
	 
      elseif tmp == "," then
	 if not forin then
	    t = t + 1
	 end
      end
      
      if tmp == "do" then break end
      fp[#fp + 1] = tmp
      tmp, i = nextexpr(str, i)
      while tmp and
	 (isBracketed(tmp) or isString(tmp) or isParenthesized(tmp) or isAccoladed(tmp))
      do
	 fp[#fp] = fp[#fp] .. " " .. tmp
	 tmp, i = nextexpr(str, i)
      end
   end
   newlevel()
   if forin then
      local cc = c + 1
      ret = "forin\t" .. tostring(frct) .. "\n"
      c = c + 1
      while c <= cc + 4 do
	 tmp = translate(fp[c], fname, flvl, false)
	 c = c + 1
	 if fp[c] and fp[c] == "," then
	    c = c + 1
	 elseif c < cc + 4 then
	    tmp = "struct\n" .. tmp
	    while c <= cc + 4 do
	       tmp = tmp .. "tac\nspec\tnil\n"
	       c = c + 2
	    end
	 end
	 ret = ret .. tmp .. "tac\n"
      end
      register(true, nil)
      register(true, nil)
      register(true, nil)
      ret = ret .. "stack\niter\t" .. tostring(t + 1) .. "\nfido\t" .. tostring(frct) .. "\n"
      c = 1
      while fp[c] ~= "in" do
	 if fp[c] ~= "," then
	    register(true, fp[c])
	 end
	 c = c + 1
      end
   else
      if t ~= 1 and t ~= 2 then
	 print("ERR") --temporaire
	 print(t)
      end
      ret = "for\t" .. tostring(frct) .. "\n"
      register(true, fp[1])
      register(true, nil)
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
      ret = ret .. tmp .. "fiend\t" .. tostring(frct) .. "\n"
   else
      ret = ret .. tmp .. "frend\t" .. tostring(frct) .. "\n"
   end
   return ret, i
end

function repscope(str, i, fname, flvl)
   rpct = rpct + 1
   
   local ret, tmp, t
   local rpct = rpct
   
   ret = "repeat\t" .. tostring(rpct) .. "\n"

   newlevel()
   tmp, i, t = compile(str, i, fname, flvl)
   test("until", t)
   ret = ret .. tmp
   
   tmp, i = evaluate(str, i, fname, flvl)
   tmp = "until\n" .. trim(tmp) 
   ret = ret .. tmp .. poplevel()
   
   ret = ret .. "rend\t" .. tostring(rpct) .. "\n"
   return ret, i
end

function arrscope(array, flvl)
   local tmp, i = nextexpr(array, 1)
   local ret, cnt = "", 0
   local elem, setsize
   local done = false
   local case = 0
   while tmp do
      case = 0
      elem = tmp
      while true do
	 if elem == "function" then
	    tmp, i = funscope(array, i)
	    ret = ret .. tmp
	    case = case + 2
	    break
	 end
	 while tmp ~= "," and tmp ~= ";" do
	    tmp, i = nextexpr(array, i)
	    if not tmp or tmp == "," or tmp == ";" then break
	    elseif tmp == "=" then
	       if not done then
		  ret = ret .. "done\n"
		  done = true
	       end
	       case = 1
	       if isBracketed(elem) then
		  ret = ret .. translate(elem:sub(2, -2), false, flvl, false) ..
		     "new\n"
	       elseif comp_flags.sas and elem == "n" then
		  setsize = true
	       else
		  ret = ret .. "str\t\"" .. elem .. "\"\nnew\n"
	       end
	       tmp, i = nextexpr(array, i)
	       elem = tmp
	       break
	    end
	    elem = elem .. " " .. tmp
	 end
	 if not tmp or tmp == "," or tmp == ";" then break end
      end
      if case == 0 then
	 ret = ret .. translate(elem, false, flvl, false)
	 if done then ret = ret .. "append\n"
	 else ret = ret .. "tac\n" end
      elseif case == 1 then
	 ret = ret .. translate(elem, false, flvl, false)
	 if setsize then
	    setsize = false
	    ret = ret .. "setsize\n"
	 else
	    ret = ret .. "put\n"
	 end
      elseif case == 2 then
	 if done then ret = ret .. "append\n"
	 else ret = ret .. "tac\n" end
      elseif case == 3 then
	 ret = ret .. "put\n"
      end
      if not done then
	 cnt = cnt + 1
      end
      if tmp then
	 if tmp == ";" then
	    if not done then
	       ret = ret .. "done\n"
	       done = true
	    end
	 else
	    test(",", tmp)
	 end
	 tmp, i = nextexpr(array, i)
      else
	 break
      end
   end
   ret = "init\t" .. cnt .. "\n" .. ret
   if not done then
      ret = ret  .. "done\n"
   end
   return ret
end

function funscope(str, i, ...)
   fnct = fnct + 1
   
   local par, tmp = true
   local t, ret   = 1
   local fnct = fnct
   local fname, clo = {...}
   local narg, s = 0, false
   local sz = size
   fname = fname[1]
   
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
   for name in pairs(clo) do
      print(name, clo[name])
   end
   test("end", t)
   ret = ret .. tmp .. "fend\t" .. tostring(fnct) .. "\n"
   size = sz
   
   tmp = ""
   t = 0
   for name in pairs(clo) do
      t = t + 1
      tmp = translate(name, fname, 0, false) .. "encl\t\"" .. name .. "\"\n" .. tmp
      for i = level, 1, -1 do
	 stk = stack[i]
	 if stk[name] then
	    stk[_CLO][name] = 0
	    break
	 end
      end
   end
   return ret, i, fnct, "rfct\t" .. fnct .. "\n", tmp
end

function getfname(name)
   local n, t = nextexpr(name, 1)
   local ret, auth = "", true
   while n do
      if isBracketed(n) then
	 n = n:sub(2, #n - 1)
	 auth = false
	 ret = ret .. "_"
      end
      if isString(n) then
	 n = n:sub(2, #n - 1)
	 auth = false
      end
      ret = ret .. n
      n, t = nextexpr(name, t)
   end
   return ret, auth
end

function test(t1, t2)
   if t1 ~= t2 then
      print("Error! Was expecting '" .. tostring(t1) .. "', got '" .. tostring(t2) .. "'.\n")
   end
end

function loadlibs()
   local file, line = io.open("library/.lib", "r")
   local current
   if file then
      repeat
	 line = file:read("line")
	 if line then
	    if line:sub(1,1) == "\t" then
	       prelibs[current][line:sub(2, #line)] = true
	    else
	       current = line:sub(1, #line - 1)
	       prelibs[current] = {}
	    end
	 end
      until not line
      file:close()
   end
end

--------------------------------------------------------------------------------
-- Program
--------------------------------------------------------------------------------
if not comp_flags.lib then loadlibs() end
newlevel()
comp_code = compile(comp_code, 1, nil, level)

if comp_flags.sub then
   local file
   file = io.open(comp_target .. ".lir", "w+")
   file:write(comp_code)
   file:close()
end

-------------------
-- Saves library --
-------------------
if comp_flags.lib then
   local pres, line = false
   local name = comp_name .. ":"
   
   file = io.open("library/.lib", "r")
   if file then
      repeat
	 line = file:read("line")
	 if line == name then
	    pres = true
	    break
	 end
      until not line
      file:close()
   end
   
   if not pres then
      file = io.open("library/.lib", "a+")
      file:write(name .. "\n")
      for i in pairs(globals) do
	 file:write("\t" .. i .. "\n")
      end
      file:close()
   end
end
