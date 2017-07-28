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

-- Miscellaneous global variables
--------------------------------------------------------------------------------
intro =
   "\t.text\n" ..
   "\t.global\t_main\n" ..
   "\t.global\tmain\n" ..
   "_main:\n" ..
   "main:\n" ..
   "\tpush\t%r12\n" ..
   "\tpush\t%r13\n" ..
   "\tpush\t%r14\n" ..
   "\tpush\t%r15\n" ..
   "\tpush\t%rbp\n" ..
   "\tmov\t%rsp, %rbp\n" ..
   "\txor\t%rbx, %rbx\n" .. 
   -- MEMORY
   "\tmov\t$134217728, %rax\n" ..
   --"\tmov\t%rax, _mem_size(%rip)\n" ..
   "\tpush\t%rax\n" ..
   "\tcall\tmmap\n" ..
   --"\tmovq\t%rax, _memory(%rip)\n" ..
   "\tmov\t%rax, %r12\n" ..
   -- GLOBALS
   "\tmov\t$524288, %rax\n" ..
   "\tpush\t%rax\n" ..
   "\tcall\tmmap\n" ..
   --"\tmovq\t%rax, _globals(%rip)\n" ..
   "\tmov\t%rax, %r13\n" ..
   -- INIT
   "\tmovq\t$0, (%r13)\n" ..
   "\tmovq\t$17, 8(%r13)\n" ..
   "\tlea\t3(, %r13, 8), %r13\n" ..
   "\tmovq\t$0, (%r12)\n" ..
   "\tmovq\t$17, 8(%r12)\n" ..
   "\tlea\t3(, %r12, 8), %r14\n" ..
   "\tadd\t$16, %r12\n"

outro =
   "\tpop\t%rbp\n" ..
   "\tpop\t%r15\n" ..
   "\tpop\t%r14\n" ..
   "\tpop\t%r13\n" ..
   "\tpop\t%r12\n" ..
   "\tmov\t$0, %rax\n" ..
   "\tret\n"

data = "\n# DATA" ..	    
   "\n################################################################################\n" ..
   ".data\n\n"

strct = 0

-- Internal stack structure
--------------------------------------------------------------------------------
buf = false

v_stack = {}
v_size  = 0

r_stack = {0}
r_size  = 0

-- Register handling functions
--------------------------------------------------------------------------------
function available()
   return not u_cont[(v_size + 1) % u_size]
end

function register()
   v_size = v_size + 1
   u_cont[v_size % u_size] = true
   v_stack[v_size] = true
   return u_name[v_size % u_size]
end

function current()
   return u_name[v_size % u_size]
end

function future()
   return u_name[(v_size + 1) % u_size]
end

function release()
   local tmp
   u_cont[v_size % u_size] = false
   if not v_stack[v_size] then
      r_stack[r_size] = nil
      tmp = tostring(-8 * r_size) .. "(%rbp)"
      r_size = r_size - 1
   else
      tmp = u_name[v_size % u_size]
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
	 ret = "\tmov\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
      else
	 r = register()
      end
      ret = ret .. "\tmov\t" .. buf .. ", " .. r .. "\n"
   end
   buf = value
   return ret
end

function use()
   local ret, r = ""
   push(nil)
   if not available() then
      r = replace()
      ret = "\tmov\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
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
function call(fname)
   return "\tsub\t$" .. tostring(8 * r_size) .. ", %rsp\n" ..
      "\tcall\t" .. fname .. "\n" ..
      "\tadd\t$" .. tostring(8 * r_size) .. ", %rsp\n"
end

function num(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if isMem(v1) and isMem(v2) then
      ret = "\tmov\t" .. v2 .. ", " .. current() .. "\n"
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
      ret = "\tmov\t" .. v2 .. ", " .. current() .. "\n"
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
      ret = "\tmov\t" .. v2 .. ", " .. current() .. "\n"
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
      ret = "\tmov\t%rdx, %r15\n"
   end
   ret = ret .. 
      "\tmov\t" .. v2 .. ", " .. "%rax\n" ..
      "\tcdq\n" ..
      "\tidiv\t" .. v1 .. "\n" ..
      "\tmov\t" .. "%rax" .. ", " .. v2 .. "\n"      
   if u_cont[5] then
      ret = ret .. "\tmov\t%r15, %rdx\n"
   end
   return ret
end

function mod(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if u_cont[5] then
      ret = "\tmov\t%rdx, %r15\n"
   end
   ret = ret .. "\txor\t%rdx, %rdx\n" ..
      "\tmov\t" .. v2 .. ", " .. "%rax\n" ..
      "\tcdq\n" ..
      "\tidiv\t" .. v1 .. "\n" ..
      "\tmov\t" .. "%rdx" .. ", " .. v2 .. "\n"      
   if u_cont[5] then
      ret = ret .. "\tmov\t%r15, %rdx\n"
   end
   return ret
end

function str(value)
   strct = strct + 1
   data = data .. "string" .. tostring(strct) .. ":\n" ..
      "\t.quad\t" .. tostring((#value - 2) * 8) .. "\n" ..
      "\t.asciz\t" .. value .. "\n"
   use()
   return ret .. "\tlea\tstring" .. tostring(strct) .. "(%rip), ".. current() .. "\n" ..
      "\tlea\t2(, %rax, 8), " .. current() .. "\n"
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
   return intro .. _translate(text, 1) .. outro
end

function _translate(text, i)
   local asm, tmp = ""
   local s, i = readline(text, i)
   local instr, value
   local tmp, call
   
   while s do
      instr, value = separate(s)
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
	 
      elseif instr == "string" then
	 asm = asm .. str(value)
	 
      elseif instr == "var" then
	 call = value
	 --asm = asm .. var(value)

      elseif instr == "add" then
	 asm = asm .. num("add")

      elseif instr == "params" then
	 tmp, i = params(text, i, tonumber(value), call)
	 call = false
	 asm = asm .. tmp
	 
      elseif instr == "chg" then
	 tmp, i = chg(text, i, tonumber(value))
	 asm = asm .. tmp

      elseif instr == "call" then
	 return asm, i

      elseif instr == "stack" then
	 return asm, i

      elseif instr == "tac" then
	 return asm, i
      end
      --------------------
      s, i = readline(text, i)
   end
   return asm
end

function params(text, i, p, call)
   local rs, vs   = r_size , v_size
   local asm, tmp = ""
   local push = p - 6
   if r_size > 0 then
      asm = "\tsub\t$" .. tostring(8 * r_size) .. ", %rsp\n"
   end
   r_size = r_size + p
   while v_size % u_size ~= 2 do
      v_size = v_size + 1
   end
   for j = 1, p do
      tmp, i = _translate(text, i)
      asm = asm .. tmp
   end
   for j = 1, push do
      asm = asm .. "\tpush\t" .. pop() .. "\n"
   end
   if push < 0 then push = 0 end
   for j = 1, p do
      if j > 6 then break end
      local t = pop()
      if t:sub(1, 1) ~= "%" then
	 asm = asm .. "\tmov\t" .. t .. ", " .. future() .. "\n"
      end
   end
   r_size, v_size = rs, vs
   --should be call or tcall (no check for now)
   s, i = readline(text, i)
   asm = asm .. "\tcall\t" .. call .. "\n"
   if r_size > 0 then
      asm = asm .. "\tadd\t$" .. tostring(8 * (r_size + push)) .. ", %rsp\n"
   end
   return asm, i
end

function chg(text, i, p)
   return _translate(text, i)
end

function set(text, i, p)
end

function ret(text, i, p)
   
end

local file = io.open(comp_file .. ".lir", "r")
text = file:read("all")
file:close()
file = io.open(comp_file .. ".s", "w+")
file:write(translate(text))
file:close()
