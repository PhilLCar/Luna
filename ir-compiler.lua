-- Register information
--------------------------------------------------------------------------------
-- Registers (16)
r = { "%rax", "%rbx", "%rcx", "%rdx", "%rbp", "%rsp", "%rsi", "%rdi",
      "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }

-- Reserved:  %rax, %rbx, %rsp, %rbp
-- Conserved: %r12, %r13, %r14, %r15
--             MEM,  GBL,  CLO,  VAR

-- Usable registers (8)
u_size = 8
u_name = { "%r10", "%r11", "%rdi", "%rsi", "%rdx", "%rcx", "%r8" , "%r9"  }
u_cont = { false , false , false , false , false , false , false , false  }

-- Calling registers (6)
c_size = 6
c_name = { "%rdi", "%rsi", "%rdx", "%rcx", "%r8" , "%r9"  }

rsp = 0

str_tbl = {}

-- Miscellaneous global variables
--------------------------------------------------------------------------------
intro =
   "\t.text\n" ..
   "\t.global\t_main\n" ..
   "\t.global\tmain\n" ..
   "_main:\n" ..
   "main:\n" ..
   "\tpushq\t%rbx\n" ..
   "\tpushq\t%r12\n" ..
   "\tpushq\t%r13\n" ..
   "\tpushq\t%r14\n" ..
   "\tpushq\t%r15\n" ..
   "\tpushq\t%rbp\n" ..
   "\tmovq\t%rsp, %rbp\n" ..
   "\txor\t%rbx, %rbx\n" .. 
   -- MEMORY
   "\tmovq\t$134217728, %rax\n" ..
   --"\tmovq\t%rax, _mem_size(%rip)\n" ..
   "\tpushq\t%rax\n" ..
   "\tcall\tmmap\n" ..
   "\tmovq\t%rax, %r12\n" ..
   -- INIT
   "\tmovq\t$0, (%r12)\n" ..
   "\tmovq\t$17, 8(%r12)\n" ..
   "\tmovq\t$17, 16(%r12)\n" ..
   "\tlea\t3(, %r12, 8), %r13\n" ..
   "\taddq\t$24, %r12\n" ..
   "\tmovq\t$0, (%r12)\n" ..
   "\tmovq\t$17, 8(%r12)\n" ..
   "\tmovq\t$17, 16(%r12)\n" ..
   "\tlea\t3(, %r12, 8), %r14\n" ..
   "\taddq\t$24, %r12\n" ..
   "\n# GENERATED CODE BEGINING" ..	    
   "\n################################################################################\n"

outro =
   "\tpopq\t%r15\n" ..
   "\tpopq\t%r14\n" ..
   "\tpopq\t%r13\n" ..
   "\tpopq\t%r12\n" ..
   "\tpopq\t%rbx\n" ..
   "\tmovq\t$0, %rax\n" ..
   "\tret\n"

need_data = false
data = "\n# DATA" ..	    
   "\n################################################################################\n" ..
   "\t.data\n\n"

-- Internal stack structure
--------------------------------------------------------------------------------
buf = false

v_stack = {}
v_size  = 0

r_stack = { true }
r_size  = 1

-- Register handling functions
--------------------------------------------------------------------------------
function available()
   return not u_cont[(v_size % u_size) + 1]
end

function register()
   v_size = v_size + 1
   u_cont[((v_size - 1) % u_size) + 1] = true
   v_stack[v_size] = true
   return u_name[((v_size - 1) % u_size) + 1]
end

function current()
   return u_name[((v_size - 1) % u_size) + 1]
end

function future()
   return u_name[(v_size % u_size) + 1]
end

function release()
   local tmp
   u_cont[((v_size - 1) % u_size) + 1] = false
   if not v_stack[v_size] then
      r_stack[r_size] = nil
      tmp = tostring(-8 * r_size) .. "(%rbp)"
      r_size = r_size - 1
   else
      tmp = u_name[((v_size - 1) % u_size) + 1]
   end
   v_stack[v_size] = nil
   v_size = v_size - 1
   return tmp
end

function replace()
   local tmp = register()
   r_size = r_size + 1
   v_stack[v_size - u_size] = false
   r_stack[r_size] = false
   return tmp
end

---------- EXTERNAL ----------

function push(value)
   local ret, r = ""
   if buf then
      if not available() then
	 r = replace()
	 ret = "\tmovq\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
      else
	 r = register()
      end
      ret = ret .. "\tmovq\t" .. buf .. ", " .. r .. "\n"
   end
   buf = value
   return ret
end

function lea(value)
   local ret, r = push(nil)
   if not available() then
      r = replace()
      ret = "\tmovq\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
   else
      r = register()
   end
   ret = ret .. "\tleaq\t" .. value .. ", " .. r .. "\n"
   return ret
end

function lock(value)
   local tmp, ret = "", ""
   if r_size > 0 then
      tmp = tostring(-8 * r_size)
   end
   r_size = r_size + 1
   r_stack[r_size] = true
   if isMem(value) then
      ret = "\tmovq\t" .. value .. ", %r15\n"
      value = "%r15"
   end
   return ret .. "\tmovq\t" .. value .. ", " .. tmp .. "(%rbp)\n"
end

function use()
   local ret, r = push(nil)
   if not available() then
      r = replace()
      ret = "\tmovq\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
   else
      r = register()
   end
   return ret
end

function pop()
   local tmp
   if buf then
      tmp = buf
      buf = nil
      return tmp
   else
      return release()
   end
end

function get(...)
   
   if buf then
      return buf
   end
   if v_stack[v_size] then
      return current()
   else
      return tostring(-8 * r_size) .. "(%rbp)"
   end
end

function isMem(reg)
   local tmp = reg:sub(1, 1)
   if tmp == "%" or tmp == "$" then
      return false
   end
   return true
end	 

---------- FUNCTIONS ----------
local _lab = 0
function label(...)
   local ret = {...}
   ret = ret[1]
   _lab = _lab + 1
   if ret then
      return ret .. _lab
   end
   return "_LU" .. _lab
end

function prep(up)
   local ret, dif = ""
   if up then
      dif = r_size - rsp - 1
   else
      dif = -rsp
   end
   if dif > 0 then
      ret = "\tsubq\t$" .. tostring(8 * dif) .. ", %rsp\n"
      rsp = rsp + dif
   elseif dif < 0 then
      ret = "\taddq\t$" .. tostring(-8 * dif) .. ", %rsp\n"
      rsp = rsp + dif
   end
   return ret
end

function num(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if isMem(v1) and isMem(v2) then
      ret = "\tmovq\t" .. v2 .. ", " .. current() .. "\n"
      v2 = current()
   end
   ret = ret .. "\t" .. op .. "\t" .. v1 .. ", " .. v2 .. "\n"
   return ret
end

-- ATTENTION AU POP
function arg1(op, tag)
   local ret = ""
   local v1 = pop()
   local v2 = pop()
   register()
   if isMem(v1) and isMem(v2) then
      ret = "\tmovq\t" .. v2 .. ", " .. current() .. "\n"
      v2 = current()
   end
   ret = ret .. "\t" .. op .. "\t" .. v1 .. ", " .. v2 .. "\n"
   return ret
end

function arg2(op, tag)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if isMem(v1) and isMem(v2) then
      ret = "\tmovq\t" .. v2 .. ", " .. current() .. "\n"
      v2 = current()
   end
   ret = ret .. "\t" .. op .. "\t" .. v1 .. ", " .. v2 .. "\n"
   return ret
end

-- div ET mod REQUIÈRE %r15 POUR FONCTIONNER!!!
function div(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if u_cont[5] then
      ret = "\tmovq\t%rdx, %r15\n"
   end
   ret = ret .. 
      "\tmovq\t" .. v2 .. ", " .. "%rax\n" ..
      "\tcdq\n" ..
      "\tidivq\t" .. v1 .. "\n" ..
      "\tmovq\t" .. "%rax" .. ", " .. v2 .. "\n"      
   if u_cont[5] then
      ret = ret .. "\tmovq\t%r15, %rdx\n"
   end
   return ret
end

function mod(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if u_cont[5] then
      ret = "\tmovq\t%rdx, %r15\n"
   end
   ret = ret ..
      "\tmovq\t" .. v2 .. ", " .. "%rax\n" ..
      "\tcdq\n" ..
      "\tidivq\t" .. v1 .. "\n" ..
      "\tmovq\t" .. "%rdx" .. ", " .. v2 .. "\n"      
   if u_cont[5] then
      ret = ret .. "\tmovq\t%r15, %rdx\n"
   end
   return ret
end

function str(value)
   local r, l = use(), str_tbl[value]
   need_data = true
   if not l then
      l = label("_ST")
      str_tbl[value] = l
      data = data .. l .. ":\n" ..
	 "\t.quad\t" .. (#value - 2) * 8 .. "\n" ..
	 "\t.asciz\t" .. value .. "\n"
   end
   return r .. "\tleaq\t" .. l .. "(%rip), %rax\n" ..
      "\tleaq\t2(, %rax, 8), " .. current() .. "\n"
end

function nt()
   local ret
   local v1 = pop()
   ret = "\tmovq\t" .. v1 .. ", %rax\n" ..
      prep(true) ..
      "\tcall\t_not\n" ..
      push("%rax")
   return ret
end

function eq()
   local ret
   local v1 = pop()
   local v2 = pop()
   ret = "\tmovq\t" .. v1 .. ", %rax\n" ..
      "\tmovq\t" .. v2 .. ", %rbx\n" ..
      prep(true) ..
      "\tcall\t_compare\n" ..
      push("%rax")
   return ret
end

function len()
   local ret
   local v1, lab = pop(), label()
   r_size = r_size + 1
   ret = prep(true) ..
      "\tmovq\t" .. v1 .. ", %rax\n" ..
      "\tsarq\t$3, %rax\n" ..
      "\tcmpq\t$65, (%rax)\n" ..
      "\tjnz\t" .. lab .. "\n" ..
      "\tcall\t_check\n" ..
      lab .. ":" ..
      push("(%rax)")
   r_size = r_size - 1
   return ret
end

function index(address, global)
   local ret, v = ""
   if global then
      if buf and string.find(buf, "%rax") then
	 ret = push(nil)
      end
      global = "\"" .. global .. "\""
      local l = str_tbl[global]
      if not l then
	 l = label("_ST")
	 str_tbl[global] = l
	 need_data = true
	 data = data .. l .. ":\n" ..
	    "\t.quad\t" .. (#global - 2) * 8 .. "\n" ..
	    "\t.asciz\t" .. global .. "\n"
      end
      ret = ret ..
	 "\tleaq\t" .. l .. "(%rip), %rax\n" ..
	 "\tleaq\t2(, %rax, 8), %rax\n"
      v = "%r13"
   else
      ret = "\tmovq\t" .. pop() .. ", %rax\n"
      v = pop()
   end
   ret = ret .. 
      "\tmovq\t" .. v .. ", %rbx\n" ..
      prep(true)
   
   if address then
      ret = ret .. 
	 "\tcall\t_new\t\n"
   else
      ret = ret .. 
	 "\tcall\t_index\t\n"
   end
   if address and not global then
      ret = ret .. push("%rax")
   else
      ret = ret .. push("(%rax)")
   end
   return ret
end

function init(text, i, p)
   local ret = push(nil)
   local rs, vs
   local tmp
   
   ret = ret ..
      "\tmovq\t$0, (%r12)\n" ..
      "\tmovq\t$17, 8(%r12)\n" ..
      "\tleaq\t" .. -8 * r_size .. "(%rbp), %rax\n" ..
      "\tmovq\t%rax, 16(%r12)\n" ..
      lea("3(, %r12, 8)") ..
      "\taddq\t$24, %r12\n"

   rs, vs = r_size, v_size
   
   tmp, i = set(text, i, p)
   ret = ret .. tmp
   
   ret = ret .. "\tmovq\t" .. get() .. ", %rax\n" .. prep(true) ..
      "\tcall\t_array_copy\n"

   for j = rs + 1, r_size do
      r_stack[j] = nil
   end
   r_size = rs
   for j = vs + 1, v_size do
      v_stack[j] = nil
   end
   v_size = vs
   
   return ret, i
end

---------- PARSING ----------
function readline(str, i)
   local s, ret = "", ""
   while ret == "" do
      if i > #str then
	 return false, i
      end
      s = str:sub(i, i)
      while s ~= "\n" and i <= #str do
	 ret = ret .. s
	 i = i + 1
	 s = str:sub(i, i)
      end
      i = i + 1
   end
   return ret, i
end

function separate(instr)
   local i = 1
   local s, ret = instr:sub(i, i), ""
   while s ~= "\t" and i <= #instr do
      ret = ret .. s
      i = i + 1
      s = instr:sub(i, i)
   end
   return ret, instr:sub(i + 1, #instr)
end

---------- PROGRAM ----------
function translate(text)
   local ret = intro .. _translate(text, 1, false) .. outro
   if need_data then
      ret = ret .. data
   end
   return ret
end

function _translate(text, i, sets)
   local asm, tmp = ""
   local s, i = readline(text, i)
   local instr, value
   local clct, vname = 0
   
   while s do
      instr, value = separate(s)
      clct = clct - 1
      --------------------	 
      if instr == "num" then
	 value = 8 * tonumber(value)
	 asm = asm .. push("$" .. tostring(value))
	 
      elseif instr == "spec" then
	 if value == "nil" then
	    asm = asm .. push("$17")
	 elseif value == "true" then
	    asm = asm .. push("$9")
	 else
	    asm = asm .. push("$1")
	 end
	 
      elseif instr == "str" then
	 asm = asm .. str(value)

      elseif instr == "ref" then
	 tmp = tonumber(value) + 1
	 if tmp > 0 then
	    tmp = tostring(-8 * tmp)
	 else
	    tmp = ""
	 end
	 asm = asm .. push(tmp .. "(%rbp)")

      elseif instr == "gbl" then
	 asm = asm .. index(sets, value)
	 
      elseif instr == "var" then
	 vname = value
	 --asm = asm .. var(value)

      elseif instr == "add" then
	 asm = asm .. num("addq")

      elseif instr == "sub" then
	 asm = asm .. num("subq")

      elseif instr == "mul" then
	 asm = asm .. num("imulq") ..
	    "\tsarq\t$3, " .. get() .. "\n"

      elseif instr == "div" then
	 asm = asm .. div()

      elseif instr == "mod" then
	 asm = asm .. mod()

      elseif instr == "not" then
	 asm = asm .. nt()
	 
      elseif instr == "eq" then
	 asm = asm .. eq()

      elseif instr == "len" then
	 asm = asm .. len()

      elseif instr == "init" then
	 tmp, i = init(text, i, tonumber(value))
	 asm = asm .. tmp

      elseif instr == "index" then
	 asm = asm .. index(sets, false)
	 

      elseif instr == "params" then
	 tmp, i = params(text, i, tonumber(value), vname)
	 call = false
	 clct = 2
	 asm = asm .. tmp
	 
      elseif instr == "chg" then
	 tmp, i = chg(text, i, tonumber(value))
	 asm = asm .. tmp
	 
      elseif instr == "set" then
	 tmp, i = set(text, i, tonumber(value))
	 asm = asm .. tmp

      elseif instr == "call" or instr == "tcall" then
	 return asm, i, instr

      elseif
	 instr == "stack" or
	 instr == "place" or
	 instr == "done"
      then
	 return asm, i, instr

      elseif instr == "tac" then
	 return asm, i, false
      end
      --------------------
      s, i = readline(text, i)
   end
   if rsp ~= 0 then
      asm = asm .. "\tleave\n"
   else
      asm = asm .. "\tpopq\t%rbp\n"
   end
   return asm
end

---------- MEMORY SETTING ----------
-- tout à refaire
function params(text, i, p, call)
   local rs, vs   = r_size , v_size
   local asm, tmp
   local push = p - 6
   r_size = r_size + p
   asm = prep(true)
   while v_size % u_size ~= 2 do
      v_size = v_size + 1
   end
   for j = 1, p do
      tmp, i = _translate(text, i, false)
      asm = asm .. tmp
   end
   for j = 1, push do
      asm = asm .. "\tpushq\t" .. pop() .. "\n"
   end
   if push < 0 then push = 0 end
   for j = 1, p do
      if j > 6 then break end
      local t = pop()
      if t:sub(1, 1) ~= "%" or t == "%rax" then
	 asm = asm .. "\tmovq\t" .. t .. ", " .. future() .. "\n"
      end
   end
   r_size, v_size = rs, vs
   --should be call or tcall (no check for now)
   s, i = readline(text, i)
   asm = asm .. "\tcall\t" .. call .. "\n"
   return asm, i
end

function chg(text, i, p)
   local asm, tmp = ""
   local rs, done = r_size
   while not done do
      tmp, i, done = _translate(text, i, true)
      if done then break end
      if buf and isMem(buf) then
	 tmp = tmp .. lea(pop())
      end
      asm = asm .. tmp .. lock(pop())
   end
   if p == 0 then
      done = false
      while not done do
	 tmp, i, done = _translate(text, i, false)
	 asm = asm .. tmp
      end
   else
      tmp, i = set(text, i, p)
      asm = asm .. tmp ..
	 "\tmovq\t$" .. tostring(-rs) .. ", %rax\n" ..
	 "\tmovq\t$" .. tostring(-p) .. ", %rbx\n" ..
	 prep(true) ..
	 "\tcall\t_transfer\n"
   end
   for j = rs + 1, r_size do
      r_stack[j] = nil
   end
   r_size = rs
   return asm, i
end

function set(text, i, p)
   local asm, tmp = ""
   local done, j = false, 1
   local r = r_size
   -- TEMPORAIRE EN ATTENDANT D'ÉCRIRE LA FONCTION DE CLEANUP
   while j <= p do
      if not done then
	 tmp, i, done = _translate(text, i, false)
      end if done then
	 tmp = push("$17")
      end
      asm = asm .. tmp .. lock(pop())
      j = j + 1
   end
   while not done do
      tmp, i = readline(text, i)
      if tmp == "stack" or tmp == "done" then
	 done = tmp
      end
   end
   if done == "done" then
      asm = asm .. "\tmovq\t$33, " .. -8 * r_size .. "(%rbp)\n"
      r_size = r_size + 1
   end
   return asm, i
end

function ret(text, i, p)
   
end

---------- MAIN ----------
local file = io.open(comp_file .. ".lir", "r")
text = file:read("all")
file:close()
file = io.open(comp_file .. ".s", "w+")
file:write(translate(text))
file:close()
