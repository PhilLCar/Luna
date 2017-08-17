-- Register information
--------------------------------------------------------------------------------
-- Registers (16)
local r = { "%rax", "%rbx", "%rcx", "%rdx", "%rbp", "%rsp", "%rsi", "%rdi",
      "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }

-- Reserved:  %rax, %rbx, %rsp, %rbp
-- Conserved: %r12, %r13, %r14, %r15
--             MEM,  GBL,  CLO,  VAR

-- Usable registers (8)
local u_size = 8
local u_name = { "%rdx", "%rcx", "%r8" , "%r9" , "%r10", "%r11", "%rdi", "%rsi" }
local u_cont = { false , false , false , false , false , false , false , false  }

-- Calling registers (6)
local c_size = 6
local c_name = { "%rdi", "%rsi", "%rdx", "%rcx", "%r8" , "%r9"  }

-- Double-precision registers (16)
local d_size = 12
local d_name = { "%xmm4" , "%xmm5" , "%xmm6" , "%xmm7" , "%xmm8" , "%xmm9" ,
	         "%xmm10", "%xmm11", "%xmm12", "%xmm13", "%xmm14", "%xmm15" }
local d_cont = { false   , false   , false   , false   , false   , false   ,
	         false   , false   , false   , false   , false   , false    }

local str_tbl = {}

-- Miscellaneous global variables
--------------------------------------------------------------------------------
local memsize = 0x8000000

if comp_flags.mem then
   mem_size = comp_flags.mem
end

local intro
if not comp_flags.lib then
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
      "\tmovq\t%rbp, _stack_base(%rip)\n" ..
      "\tmovq\t$" .. memsize .. ", %rax\n" ..
      "\tmovq\t%rax, _mem_size(%rip)\n" ..
      "\tpushq\t%rax\n" ..
      "\tcall\tmmap\n" ..
      "\tmovq\t%rax, %r12\n" ..
      "\tmovq\t%rax, _mem_max(%rip)\n" ..
      "\taddq\t$" .. memsize / 2 .. ", _mem_max(%rip)\n" ..
      -- INIT
      "\tmovq\t$0, (%r12)\n" ..
      "\tmovq\t$17, 8(%r12)\n" ..
      "\tmovq\t$17, 16(%r12)\n" ..
      "\tlea\t3(, %r12, 8), %r13\n" ..
      "\taddq\t$24, %r12\n" ..
      "\tmovq\t$17, %r14\n" ..
      "\tcall\t_prep_gc\n"
   for i in pairs(libs) do
      intro = intro .. "\tcall\t_load_" .. i .. "\n"
   end
else
   intro =
      "\t.text\n" ..
      "\t.global\t_load_" .. comp_name .. "\n" ..
      "_load_" .. comp_name .. ":\n" ..
      "\tpushq\t%rbp\n" ..
      "\tmovq\t%rsp, %rbp\n"
end

intro = intro ..
   "\n# GENERATED CODE BEGINING" ..	    
   "\n################################################################################\n\n"

local func = "\n# FUNCTIONS" ..	    
   "\n################################################################################\n\n"

local need_data = false
local data = "\n# DATA" ..	    
   "\n################################################################################\n\n" ..
   "\t.data\n\n"

local outro = ""

if  not comp_flags.lib then
   outro = 
      "\tpopq\t%r15\n" ..
      "\tpopq\t%r14\n" ..
      "\tpopq\t%r13\n" ..
      "\tpopq\t%r12\n" ..
      "\tpopq\t%rbx\n" ..
      "\tmovq\t$0, %rax\n" ..
      "\tret\n"
else
   outro = 
      "\tmovq\t$0, %rax\n" ..
      "\tret\n"
end

-- Internal stack structure
--------------------------------------------------------------------------------
local buf = false

local f_size  = 0

local v_stack = {}
local v_size  = 0

local r_size = 1
local rsp = 0

local r_index = 1

local ref_mask = false

-- Register handling functions
--------------------------------------------------------------------------------
function onstack()
   return d_cont[(f_size % d_size) + 1]
end

function available(double)
   if double then
      return not d_cont[(f_size % d_size) + 1]
   else
      return not u_cont[((v_size - 1 + r_index) % u_size) + 1]
   end
end

function register(double)
   v_size = v_size + 1
   if not double then
      u_cont[((v_size - 2 + r_index) % u_size) + 1] = true
      v_stack[v_size] = true
      return u_name[((v_size - 2 + r_index) % u_size) + 1]
   else
      f_size = f_size + 1
      -- Donne au %r son %xmm
      u_cont[((v_size - 2 + r_index) % u_size) + 1] = ((f_size - 1) % d_size) + 1
      -- Donne au %xmm son %r
      d_cont[((f_size - 1) % d_size) + 1] = u_name[((v_size - 2 + r_index) % u_size) + 1]
      return d_name[((f_size - 1) % d_size) + 1]
   end
end

function current()
   if v_stack[v_size] ~= nil then
      return u_name[((v_size - 2 + r_index) % u_size) + 1]
   else
      return d_name[((f_size - 1) % d_size) + 1]
   end
end

function future(double)
   if double then
      return d_name[(f_size % d_size) + 1]
   else
      return u_name[((v_size - 1 + r_index) % u_size) + 1]
   end
end

function release()
   local tmp = u_cont[((v_size - 2 + r_index) % u_size) + 1]
   u_cont[((v_size - 2 + r_index) % u_size) + 1] = false
   if tonumber(tmp) then
      d_cont[((f_size - 1) % d_size) + 1] = false
      tmp = current()
      f_size = f_size - 1
   elseif not v_stack[v_size] then
      tmp = tostring(-8 * r_size) .. "(%rbp)"
      if v_stack[v_size] == nil then
	 for i, v in ipairs(d_cont) do
	    if v == tmp then
	       tmp = d_name[i]
	       d_cont[i] = false
	       f_size = f_size - 1
	       break
	    end
	 end
      end
      r_size = r_size - 1
   else
      tmp = u_name[((v_size - 2 + r_index) % u_size) + 1]
   end
   v_stack[v_size] = nil
   v_size = v_size - 1
   return tmp
end

function replace()
   local n = u_cont[((v_size - 1 + r_index) % u_size) + 1]
   local tmp = register()
   r_size = r_size + 1
   if tonumber(n) then
      d_cont[n] = tostring(-8 * r_size) .. "(%rbp)"
      return false
   else
      v_stack[v_size - u_size] = false
      return tmp
   end
end

function promote()
   v_stack[v_size] = true
   r_size = r_size - 1
   return current()
end

function align(reg)
   for i, v in ipairs(u_name) do
      if v == reg then
	 r_index = i
	 break
      end
   end
end

-- Stack managment functions
--------------------------------------------------------------------------------
function newdouble(value)
   local l, d, r = str_tbl[tonumber(value)]
   local ret = push(nil)
   if tonumber(value) then
      need_data = true
      if not l then
	 l = label("_DB")
	 str_tbl[tonumber(value)] = l
	 data = data .. l .. ":\n" ..
	    "\t.double\t" .. value .. "\n"
      end
   end
   if not available() then
      r = replace()
      --ret = "#" .. tostring(-8 * r_size) .. "(%rbp)\t" .. tostring(u_cont[1]) .."\n"
      if r then
	 ret = ret .. "#\n\tmovq\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
      end
      r = true
   end
   if not available(true) then
      v_stack[v_size - f_size + 1] = false
      ret = ret ..
	 "\tmovsd\t" .. future(true) .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %r15\n" ..
	 "\taddq\t$8, %r12\n" ..
	 "\tmovq\t%r15, " .. onstack() .. "\n"
   end
   if r then
      v_stack[v_size] = nil
      v_size = v_size - 1
   end
   d = register(true)
   if tonumber(value) then
      ret = ret .. "\tmovsd\t" .. l .. "(%rip), " .. d .. "\n"
   else
      ret = ret .. "\tmovsd\t" .. value .. ", " .. d .. "\n"
   end
   return ret
end

function push(value)
   local ret, r = ""
   if buf then
      if not available() then
	 r = replace()
	 if r then
	    ret = "\tmovq\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
	 end
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
      if r then
	 ret = "\tmovq\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
      end
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
   if isMem(value) then
      ret = "\tmovq\t" .. value .. ", %r15\n"
      value = "%r15"
   end
   if isDouble(value) then
      ret = ret ..
	 "\tmovsd\t" .. value .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %r15\n" ..
	 "\taddq\t$8, %r12\n"
      value = "%r15"
   end
   return ret .. "\tmovq\t" .. value .. ", " .. tmp .. "(%rbp)\n"
end

function unlock()
   local tmp = ""
   r_size = r_size - 1
   if r_size > 0 then
      tmp = tostring(-8 * r_size)
   end
   return push(tmp .. "(%rbp)")
end

function use()
   local ret, r = push(nil)
   if not available() then
      r = replace()
      if r then
	 ret = ret .. "\tmovq\t" .. r .. ", " .. tostring(-8 * r_size) .. "(%rbp)\n"
      end
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

function get() 
   if buf then
      return buf
   elseif v_stack[v_size] == false then
      return tostring(-8 * r_size) .. "(%rbp)"
   else
      return current()
   end
end

function isMem(reg)
   local tmp = reg:sub(1, 1)
   if tmp == "%" or tmp == "$" then
      return false
   end
   return true
end

function isDouble(reg)
   if reg:find("xmm") then
      return true
   end
   return false
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

-- Code generation function
--------------------------------------------------------------------------------
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

function flt(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if not isDouble(v1) then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rax\n" ..
	 "\tsarq\t$3, %rax\n"
      v1 = "(%rax)"
   end
   if not isDouble(v2) then
      pop()
      if isDouble(v1) then
	 ret = ret ..
	    "\tmovsd\t" .. v1 .. ", %xmm0\n"
	 v1 = "%xmm0"
      end
      ret = ret ..
	 "\tmovq\t" .. v2 .. ", %rbx\n"  ..
	 "\tsarq\t$3, %rbx\n" ..
	 newdouble("(%rbx)")
      v2 = get()
   end
   ret = ret ..
      "\t" .. op .. "sd\t" .. v1 .. ", " .. v2 .. "\n"
   return ret
end

function eq(n)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   local l1, l2 = label("_T"), label()
   if isDouble(v1) then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rbx\n"
      v1 = "%rbx"
   end
   if isDouble(v2) then
      pop()
      ret = ret ..
	 "\tmovq\t" .. v2 .. ", %rax\n" ..
	 push("%rax")
      v2 = "%rax"
   end
   ret =
      "\tcmpq\t" .. v1 .. ", " .. v2 .. "\n"
   if n then
      ret = ret .. "\tjz\t" .. l1 .. "\n"
   else
      ret = ret .. "\tjnz\t" .. l1 .. "\n"
   end
   ret = ret ..
      "\tmovq\t$1, " .. v2 .. "\n" ..
      "\tjmp\t" .. l2 .. "\n" ..
      l1 .. ":\tmovq\t$9, " .. v2 .. "\n" ..
      l2 .. ":"
   return ret
end

function pow()
   local ret
   local v1, v2 = pop(), pop()
   if not isDouble(v1) then
      ret = 
	 "\tmovq\t" .. v1 .. ", %rax\n" ..
	 "\tsarq\t$3, %rax\n" .. 
	 "\tmovsd\t(%rax), %xmm1\n"
   else
      ret = "\tmovsd\t" .. v1 .. ", %xmm1\n"
   end
   if not isDouble(v2) then
      ret = ret ..
	 "\tmovq\t" .. v2 .. ", %rbx\n" ..
	 "\tsarq\t$3, %rbx\n" .. 
	 "\tmovsd\t(%rbx), %xmm0\n"
   else
      ret = ret .. "\tmovsd\t" .. v2 .. ", %xmm0\n"
   end
   ret = ret .. prep(true) ..
      "\tcall\t_pow\n" ..
      newdouble("%xmm0")
   return ret
end

function mod(intsr)
   local ret = ""
   local v1, v2 = pop(), pop()
   if not isDouble(v1) then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rax\n" ..
	 "\tsarq\t$3, %rax\n"
      v1 = "(%rax)"
   end
   if not isDouble(v2) then
      ret = ret ..
	 "\tmovq\t" .. v2 .. ", %rbx\n" ..
	 "\tsarq\t$3, %rbx\n"
      v2 = "(%rbx)"
   end
   ret = ret ..
      "\tmovsd\t" .. v1 .. ", %xmm1\n" ..
      "\tmovsd\t" .. v2 .. ", %xmm0\n" ..
      prep(true) ..
      "\tcall\t_mod\n" ..
      newdouble("%xmm0")
   return ret
end

function neg()
   local ret = push(nil)
   local v1, v2 = get(), nil
   if not isDouble(v1) then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rbx\n" ..
	 "\tsarq\t$3, %rbx\n" ..
	 "\tmovq\t(%rbx), %xmm0\n"
      v1 = "%xmm0"
      v2 = "(%rbx)"
   end
   ret = ret ..
      "\tmovsd\t" .. v1 .. ", (%r12)\n" ..
      "\txorpd\t" .. v1 .. ", " .. v1 .. "\n" ..
      "\tsubsd\t(%r12), " .. v1 .. "\n"
   if v2 then
      ret = ret .. "\tmovsd\t" .. v1 .. ", " .. v2 .. "\n"
   end
   return ret
end

function inv(instr)
   local ret = push(nil)
   local v1 = pop()
   if not isDouble(v1) then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rbx\n" ..
	 "\tsarq\t$3, %rbx\n"
      v1 = "(%rbx)"
   end
   ret = ret ..
      "\tcvtsd2si " .. v1 .. ", %rax\n" ..
      "\txorq\t$-1, %rax\n" ..
      "\tcvtsi2sd %rax, %xmm0\n"  ..
      newdouble("%xmm0")
   return ret
end

function bits(instr, value)
   local ret = ""
   local v1, v2
   local pres = false
   if value then
      v1 = pop()
      value = "$" .. value
   else
      v2 = pop()
      v1 = pop()
      if not isDouble(v2) then
	 ret = ret ..
	    "\tmovq\t" .. v2 .. ", %rbx\n" ..
	    "\tsarq\t$3, %rbx\n"
	 v2 = "(%rbx)"
      end
   end
   if not isDouble(v1) then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rax\n" ..
	 "\tsarq\t$3, %rax\n"
      v1 = "(%rax)"
   end
   ret = ret .. "\tcvtsd2si " .. v1 .. ", %rax\n"
   if instr == "sal" or instr == "sar" or instr == "shr" then
      if not value then
	 if u_cont[2] then
	    ret = ret .. "\tmovq\t%rcx, %r15\n"
	    pres = true
	 end
	 ret = ret ..
	    "\tcvtsd2si " .. v2 .. ", %rcx\n"
	 value = "%cl"
      end
   else
      ret = ret .. "\tcvtsd2si " .. v2 .. ", %rbx\n"
      value = "%rbx"
   end
   ret = ret ..
      "\t" .. instr .. "q\t" .. value .. ", %rax\n" ..
      "\tcvtsi2sd %rax, %xmm0\n" ..
      newdouble("%xmm0")
   if instr == "sal" or instr == "sar" or instr == "shr" then
      if u_cont[2] and pres then
	 ret = ret .. "\tmovq\t%r15, %rcx\n"
      end
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
	 "\t.quad\t" .. (#value - 2) .. "\n" ..
	 "\t.asciz\t" .. value .. "\n"
   end
   return r .. "\tleaq\t" .. l .. "(%rip), %rax\n" ..
      "\tleaq\t2(, %rax, 8), " .. current() .. "\n"
end

function bool(instr, value, text, i)
   local rs = r_size
   local tag = "_CH" .. value
   local ret, tmp = protect(false)
   local v, jmp

   if instr == "and" then
      jmp = "jz"
   else
      jmp = "jnz"
   end
   
   tmp, i = _translate(text, i, false)
   ret = ret .. tmp .. push(nil)
   v = get()
   if isDouble(v) then
      ret = ret ..
	 "\tmovsd\t" .. pop() .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rax\n" ..
	 "\taddq\t$8, %r12\n"
      if instr == "or" then
	 ret = ret .. "\tjmp\t" .. tag .. "\n"
      end
   else
      ret = ret ..
	 "\tmovq\t" .. get() .. ", %rax\n" ..
	 "\torq\t$17, " .. get() .. "\n" ..
	 "\tcmpq\t$17, " .. pop() .. "\n" ..
	 "\t" .. jmp .. "\t" .. tag .. "\n"
   end
   
   tmp, i = _translate(text, i, false)
   ret = ret .. tmp .. push(nil)
   v = get()
   if isDouble(v) then
      ret = ret ..
	 "\tmovsd\t" .. pop() .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rax\n" ..
	 "\taddq\t$8, %r12\n"
      if instr == "or" then
	 ret = ret .. "\tjmp\t" .. tag .. "\n"
      end
   else
      ret = ret .. "\tmovq\t" .. pop() .. ", %rax\n"
   end
   ret = ret ..
      tag .. ":" ..
      protect(rs) .. push("%rax") ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
   rsp = r_size - 1
   return ret, i
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

function opcall2(func)
   local ret
   local v1 = pop()
   local v2 = pop()
   if isDouble(v1) then
      if isDouble(v2) then
	 ret =
	    "\tmovsd\t" .. v1 .. ", (%r12)\n" ..
	    "\tmovsd\t" .. v2 .. ", 8(%r12)\n" ..
	    "\tleaq\t6(, %r12, 8), %rax\n" ..
	    "\tleaq\t70(, %r12, 8), %rbx\n" ..
	    "\taddq\t$16, %r12\n"
      else
	 ret =
	    "\tmovsd\t" .. v1 .. ", (%r12)\n" ..
	    "\tmovq\t" .. v2 .. ", %rbx\n" ..
	    "\tleaq\t6(, %r12, 8), %rax\n" ..
	    "\taddq\t$8, %r12\n"
      end
   elseif isDouble(v2) then
      ret =
	 "\tmovq\t" .. v1 .. ", %rax\n" ..
	 "\tmovsd\t" .. v2 .. "\t, (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rbx\n" ..
	 "\taddq\t$8, %r12\n"
   else
      if v1 ~= "%rax" then
	 ret =
	    "\tmovq\t" .. v1 .. ", %rax\n" ..
	    "\tmovq\t" .. v2 .. ", %rbx\n"
      else
	 ret = "\tmovq\t" .. v2 .. ", %rbx\n"
      end
   end
   ret = ret .. prep(true) ..
      "\tcall\t_" .. func .. "\n" ..
      push("%rax")
   return ret
end

function len()
   local ret
   local v1, lab = pop(), label()
   ret = prep(true) ..
      "\tmovq\t" .. v1 .. ", %rax\n" ..
      "\tsarq\t$3, %rax\n" ..
      "\tcmpq\t$65, (%rax)\n" ..
      "\tjnz\t" .. lab .. "\n" ..
      "\tcall\t_check\n" ..
      lab .. ":" ..
      "\tcvtsi2sd (%rax), %xmm0\n" ..
      newdouble("%xmm0")
   return ret
end

---------- Closure related ----------
function encl(value)
   local r, l = prep(true), str_tbl[value]
   need_data = true
   if not l then
      l = label("_ST")
      str_tbl[value] = l
      data = data .. l .. ":\n" ..
	 "\t.quad\t" .. (#value - 2) .. "\n" ..
	 "\t.asciz\t" .. value .. "\n"
   end
   return r ..
      "\tmovq\t" .. pop() .. ", %rbx\n" ..
      "\tleaq\t" .. l .. "(%rip), %rax\n" ..
      "\tleaq\t2(, %rax, 8), %rax\n" ..
      "\tcall\t_encl\n"
end

function clo(sets, value)
   value = "\"" .. value .. "\""
   local r, l = prep(true), str_tbl[value]
   need_data = true
   if not l then
      l = label("_ST")
      str_tbl[value] = l
      data = data .. l .. ":\n" ..
	 "\t.quad\t" .. (#value - 2) .. "\n" ..
	 "\t.asciz\t" .. value .. "\n"
   end
   if sets then
      r = r .. push("%rax")
   else
      r = r .. push("(%rax)")
   end
   return r ..
      "\tleaq\t" .. l .. "(%rip), %rax\n" ..
      "\tleaq\t2(, %rax, 8), %rax\n" ..
      "\tcall\t_clo_ref\n"
end

---------- Array related ----------
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
	    "\t.quad\t" .. (#global - 2) .. "\n" ..
	    "\t.asciz\t" .. global .. "\n"
      end
      ret = ret ..
	 "\tleaq\t" .. l .. "(%rip), %rax\n" ..
	 "\tleaq\t2(, %rax, 8), %rax\n"
      v = "%r13"
   else
      local vd = pop()
      if isDouble(vd) then
	 ret = "\tmovsd\t" .. vd .. ", (%r12)\n" .. -- changed
	    "\tleaq\t6(, %r12, 8), %rax\n" ..
	    "\taddq\t$8, %r12\n"
      else
	 ret = ret .. "\tmovq\t" .. vd .. ", %rax\n"
      end
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

function new()
   local ret, v = "", pop()
   if isDouble(v) then
      ret = "\tmovsd\t" .. v .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rax\n" ..
	 "\taddq\t$8, %r12\n"
      v = "%rax"
   else
      ret = "\tmovq\t" .. v .. ", %rax\n"
   end
   ret = ret .. 
      "\tmovq\t" .. get() .. ", %rbx\n" ..
      prep(true) .. "\tcall\t_new\t\n"
      ret = ret .. push("%rax")
   return ret
end

function findex()
   local ret, v1, v2 = "", pop(), pop()
   if isDouble(v1) then
      ret = "\tmovsd\t" .. v1 .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rax\n" ..
	 "\taddq\t$8, %r12\n"
      v1 = "%rax"
   else
      ret = "\tmovq\t" .. v1 .. ", %rax\n"
   end
   ret = ret .. 
      "\tmovq\t" .. v2 .. ", %rbx\n" ..
      prep(true) ..
      "\tpushq\t%rbx\n" ..
      "\tcall\t_index\t\n" ..
      "\tpopq\t%r15\n"..
      push("%r15") .. push("(%rax)")
   return ret
end

function put()
   local ret = ""
   local v1, v2 = pop(), pop()
   if isMem(v2) then
      ret = "\tmovq\t" .. v2 .. ", %rax\n"
      v2 = "%rax"
   end
   if isDouble(v1) then
      ret = ret .. "\tmovsd\t" .. v1 .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rbx\n" ..
	 "\taddq\t$8, %r12\n"
      v1 = "%rbx"
   end
   ret = ret .. "\tmovq\t" .. v1 .. ", (" .. v2 .. ")\n"
   return ret
end

function setsize()
   local asm, tmp
   tmp = pop()
   asm = prep(true)
   if not isDouble(tmp) then
      if isMem(tmp) then
	 asm = asm .. "\tmovq\t" .. tmp .. ", %rax\n"
	 tmp = "%rax"
      end
      asm = asm .. "sarq\t$3, " .. tmp .. "\n" ..
	 "\tmovq\t(" .. tmp .. "), %xmm0\n"
      tmp = "%xmm0"
   else
      asm = asm ..
	 "\tmovq\t" .. get() .. ", %rbx\n" ..
	 "\tcvtsd2si " .. tmp .. ", %rax\n" ..
	 "\tcall\t_set_size\n"
   end
   return asm
end

function append()
   local ret, v = "", pop()
   if isDouble(v) then
      ret = "\tmovsd\t" .. v .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rax\n" ..
	 "\taddq\t$8, %r12\n"
      v = "%rax"
   else
      ret = "\tmovq\t" .. v .. ", %rax\n"
   end
   ret = ret .. 
      "\tmovq\t" .. get() .. ", %rbx\n" ..
      prep(true) .. "\tcall\t_append\n"
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
   
   ret = ret .. "\tmovq\t" .. get() .. ", %rax\n" .. 
      "\tcall\t_array_copy\n" ..
      "\tmovq\t%rbp, %rsp\n"

   rsp = 0
   
   r_size = rs
   for j = vs + 1, v_size do
      v_stack[j] = nil
   end
   v_size = vs
   
   return ret, i
end

---------- Function related ----------
function build(nargs, varargs, fname)
   local ret = ""
   local p = 1
   if varargs then ret = "\tmovq\t%r15, (%r12)\n" end
   ret = ret ..
      "\tmovq\t$" .. nargs .. ", %rax\n" ..
      "\tcall\t_nil_fill\n"
   if varargs then
      ret = ret ..
	 "\tcall\t_varargs\n"
      if nargs == 0 then
	 ret = ret .. "\tmovq\t%r15, %rdi\n"
	 nargs = 1
      elseif nargs <= 6 then
	 ret = ret .. "\tmovq\t%r15, " .. c_name[nargs] .. "\n"
      else
	 ret = ret .. "\tmovq\t%r15, " .. 8 * (nargs - 6) .. "(%rsp)\n"
      end
   end
   if fname then
      ret = ret .. fname .. ":\n"
   end
   ret = ret ..
      "\tpushq\t%rbp\n" ..
      "\tmovq\t%rsp, %rbp\n"
   while p <= nargs and p <= 6 do
      ret = ret .. "\tmovq\t" .. c_name[p] .. ", " .. -8 * r_size .. "(%rbp)\n"
      r_size = r_size + 1
      p = p + 1
   end
   if nargs > 6 then
      ref_mask = true
      ref_mask_low = 6
      ref_mask_up  = nargs
   end
   return ret
end

function protect(down)
   local r, val = "", true
   if down then
      while r_size ~= down do
	 r = r .. unlock()
      end
   else
      if buf then
	 r = r .. lock(pop())
      end
      while val do
	 for i, v in ipairs(u_cont) do
	    val = false
	    if v then
	       val = true
	       break
	    end
	 end
	 if val then
	    r = r .. lock(pop())
	 end
      end
      for i, v in ipairs(d_cont) do
	 if v then
	    r = r .. "\tmovsd\t" .. d_name[i] .. ", (%r12)\n" ..
	       "\tleaq\t6(, %r12, 8), %rax\n" ..
	       "\taddq\t$8, %r12\n" ..
	       "\tmovsd\t%rax, " .. v .. "\n"
	    d_cont[i] = false
	    f_size = f_size - 1
	    break
	 end
      end
   end
   return r
end

-- Environment functions
--------------------------------------------------------------------------------
function ifenv(text, i, p, loop)
   local rs = r_size
   local ret, tmp1, tmp2 = protect(false) .. "_IF" .. p .. ":\n"
   local tag, jlab, v
   
   tmp1, i = _translate(text, i, false, false)
   v = pop()
   tmp2, i, tag = _translate(text, i, false, loop)
   if tag == "else" then
      jlab = "_EL" .. p
   else
      jlab = "_FI" .. p
   end
   if v:sub(1, 1) == "$" then
      tmp1 = tmp1 .. "\tmovq\t" .. v .. ", %rax\n"
      v = "%rax"
   end
   ret = ret .. tmp1 .. "_TH" .. p .. ":\n" ..
      "\tcmpq\t$1, " .. v .. "\n" ..
      "\tjz\t" .. jlab .. "\n" ..
      "\tcmpq\t$17, " .. v .. "\n" ..
      "\tjz\t" .. jlab .. "\n" ..
      tmp2
   if tag == "else" then
      tmp1, i = _translate(text, i, false, loop)
      ret = ret ..
	 "\tjmp\t_FI" .. p .. "\n" .. jlab .. ":\n" ..
	 tmp1 .. "_FI" .. p .. ":\n"
   else
      ret = ret .. jlab .. ":\n" .. protect(rs) ..
	 "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
      rsp = r_size - 1
   end
   return ret, i
end

function whenv(text, i, p)
   local rs = r_size
   local ret, tmp = protect(false)
   local tag, v

   rsp = r_size - 1
   ret = "_WH" .. p .. ":\n" ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
      
   
   tmp, i = _translate(text, i, false, false)
   v = pop()
   if v:sub(1, 1) == "$" then
      tmp = tmp .. "\tmovq\t" .. v .. ", %rax\n"
      v = "%rax"
   end
   ret = ret .. tmp .. "_WD" .. p .. ":\n" ..
      "\tcmpq\t$1, " .. v .. "\n" ..
      "\tjz\t_WE" .. p .. "\n" ..
      "\tcmpq\t$17, " .. v .. "\n" ..
      "\tjz\t_WE" .. p .. "\n"

   tmp, i, tag = _translate(text, i, false, "_WE" .. p)
   
   ret = ret .. tmp ..
      "\tjmp\t_WH" .. p .. "\n" ..
      "_WE" .. p .. ":\n" .. protect(rs) ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
   rsp = r_size - 1
   return ret, i
end

function rpenv(text, i, p)
   local rs = r_size
   local ret, tmp = protect(false)
   local tag, v

   rsp = r_size - 1
   ret = ret ..  "_RP" .. p .. ":\n" ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
   
   tmp, i = _translate(text, i, false, false)
   ret = ret .. tmp .. "_UN" .. p .. ":\n"
   
   tmp, i, tag = _translate(text, i, false, "_RE" .. p)
   v = pop()
   if v:sub(1, 1) == "$" then
      tmp = tmp .. "\tmovq\t" .. v .. ", %rax\n"
      v = "%rax"
   end
   
   ret = ret .. tmp ..
      "\tcmpq\t$1, " .. v .. "\n" ..
      "\tjz\t_RP" .. p .. "\n" ..
      "\tcmpq\t$17, " .. v .. "\n" ..
      "\tjz\t_RP" .. p .. "\n" ..
      "_RE" .. p .. ":\n" ..
      protect(rs) ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n" 
   rsp = r_size - 1
   return ret, i
end

function frenv(text, i, p)
   local rs = r_size
   local ret, tmp
   local tag, v
   ret = protect(false)
   tmp, i = _translate(text, i, false, false)
   v = pop()
   if isMem(v) then
      tmp = tmp .. "\tmovq\t" .. v .. ", %rax\n" ..
	 "\tsarq\t$3, %rax\n" ..
	 "\tmovq\t(%rax), %xmm0\n" ..
	 lock("%xmm0")
   elseif isDouble(v) then
      tmp = tmp .. "\tmovsd\t" .. v .. ", %xmm0\n" ..
	 lock("%xmm0")
   else
      tmp = tmp .. "\tmovq\t" .. v .. ", %rax\n" ..
	 "\tsarq\t$3, %rax\n" ..
	 "\tmovq\t(%rax), %xmm0\n" ..
	 lock("%xmm0")
   end
   ret = ret .. tmp .. "\tmovq\t%xmm0, " .. -8 * r_size .. "(%rbp)\n"
   r_size = r_size + 1
   for k = 1, 2 do
      tmp, i = _translate(text, i, false, false)
      v = pop()
      if isMem(v) then
	 tmp = tmp .. "\tmovq\t" .. v .. ", %rax\n" ..
	    "\tsarq\t$3, %rax\n" .. lock("(%rax)")
      elseif isDouble(v) then
	 tmp = tmp .. "\tmovsd\t" .. v .. ", " .. -8 * r_size .. "(%rbp)\n"
	 r_size = r_size + 1
      else
	 tmp = tmp ..
	    "\tsarq\t$3, " .. v .. "\n" .. lock(v)
      end
      ret = ret .. tmp
   end
   
   rsp = r_size - 1
   
   ret = ret .. 
      "\tmovsd\t" .. -8 * (r_size - 3) .. "(%rbp), %xmm0\n" ..
      "_FRC" .. p .. ":\n" ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n" ..
      "\txorpd\t%xmm1, %xmm1\n" ..
      "\tcmpsd\t$6, " .. -8 * (r_size - 1) .. "(%rbp), %xmm1\n" ..
      "\tmovq\t%xmm1, %rax\n" ..
      "\tcmpq\t$-1, %rax\n" ..
      "\tjz\t_FRN" .. p .. "\n" ..
      "\tmovsd\t%xmm0, %xmm1\n" .. -- Base
      "\tcmpsd\t$6, " .. -8 * (r_size - 2) .. "(%rbp), %xmm1\n" .. -- Comparateur
      "\tmovq\t%xmm1, %rax\n" ..
      "\tcmpq\t$-1, %rax\n" ..
      "\tjz\t_FRE" .. p .. "\n" ..
      "\tjmp\t_FRS" .. p .. "\n" ..
      "_FRN" .. p .. ":\tmovsd\t%xmm0, %xmm1\n" ..
      "\tcmpsd\t$1, " .. -8 * (r_size - 2) .. "(%rbp), %xmm1\n" ..
      "\tmovq\t%xmm1, %rax\n" ..
      "\tcmpq\t$-1, %rax\n" ..
      "\tjz\t_FRE" .. p .. "\n" ..
      "_FRS" .. p .. ":\n" 

   tmp, i = _translate(text, i, false, "_FRE" .. p)
   
   ret = ret .. tmp ..
      "\tmovsd\t" .. -8 * (r_size - 1) .. "(%rbp), %xmm1\n" ..
      "\tmovsd\t" .. -8 * (r_size - 3) .. "(%rbp), %xmm0\n" ..
      "\taddsd\t%xmm1, %xmm0\n" ..
      "\tmovsd\t%xmm0, " .. -8 * (r_size - 3) .. "(%rbp)\n" ..
      "\tmovq\t" .. -8 * (r_size - 4) .. "(%rbp), %rax\n" ..
      "\tsarq\t$3, %rax\n" ..
      "\tmovsd\t%xmm0, (%rax)\n" ..
      "\tjmp\t_FRC" .. p .. "\n" ..
      "_FRE" .. p .. ":\n"

   --tmp, i = _translate(text, i, false, false)
   
   r_size = r_size - 4
   ret = ret .. protect(rs) ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
   rsp = r_size - 1

   return ret, i
end

function fienv(text, i, p)
   local rs = r_size
   local ret, tmp
   local tag, v
   local l1, l2, l3 = label(), label(), label()
   ret = protect(false) 
   ret, i = set(text, i, 3)

   tmp, i = readline(text, i)
   tag, v = separate(tmp)
   tmp, i = readline(text, i) -- fido
   v = tonumber(v)
   
   ret = ret ..
      "_FIC" .. p .. ":\n" ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n" ..
      "\tmovq\t" .. -8 * (r_size - 3) .. "(%rbp), %rax\n" ..
      "\tsarq\t$3, %rax\n" ..
      "\tpushq\t%r14\n" ..
      "\tmovq\t" .. -8 * (r_size - 2) .. "(%rbp), %rdi\n" ..
      "\tmovq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsi\n" ..
      "\tmovq\t8(%rax), %r14\n" ..
      "\tcall\t*(%rax)\n" ..
      "\tpopq\t%r14\n" ..
      "\tcmpq\t$17, %rax\n" ..
      "\tjz\t_FIE" .. p .. "\n" ..
      "\tmovq\t%rax, " .. -8 * (r_size - 1) .. "(%rbp)\n" ..
      "\tcmpq\t$33, %rax\n" ..
      "\tjz\t" .. l1 .. "\n" ..
      "\tpushq\t%rax\n" ..
      "\tleaq\t" .. -8 * (v - 1) .. "(%rsp), %r15\n" ..
      "\tcmp\t$0, %rbx\n" ..
      "\tjz\t" .. l1 .. "\n" ..
      l2 .. ":\tcmpq\t$33, (%rbx)\n" ..
      "\tjz\t" .. l1 .. "\n" ..
      "\tpushq\t(%rbx)\n" ..
      "\tsubq\t$8, %rbx\n" ..
      "\tjmp\t" .. l2 .. "\n" ..
      l1 .. ":\tcmpq\t%rsp, %r15\n" ..
      "\tjge\t" .. l3 .. "\n" ..
      "\tpushq\t$17\n" ..
      "\tjmp\t" .. l1 .. "\n" ..
      l3 .. ":\tmovq\t%r15, %rsp\n"
   r_size = r_size + v
   rsp = r_size - 1

   tmp, i = _translate(text, i, false, "_FIE" .. p)

   ret = ret .. tmp ..
      "\tjmp\t_FIC" .. p .. "\n" ..
      "_FIE" .. p .. ":\n"

   r_size = r_size - v - 3
   ret = ret .. protect(rs) ..
      "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n" 
   rsp = r_size - 1
   return ret, i
end

-- State altering functions
--------------------------------------------------------------------------------
function fct(text, i, value)
   local ins, val
   local name
   local ret, tmp = "\t.align\t8\n" ..
      "\t.fill\t1, 1, 0x90\n" ..
      "_FN" .. value .. ":\n"

   tmp, i = readline(text, i)
   ins, val = separate(tmp)
   
   if ins == "fname" then
      name = val
      tmp, i = readline(text, i)
      ins, val = separate(tmp)
   end
   val = tonumber(val)
   
   align("%rdx")
   r_size  = 1
   v_size  = 0
   f_size  = 0
   v_stack = {}
   u_cont  = { false, false, false, false, false, false, false, false }
   d_cont  = { false, false, false, false, false, false, false, false, false, false, false, false }
   rsp = 0

   ret = ret .. build(val, ins == "nargs", name)
   
   tmp, i = _translate(text, i, false, false)
   tmp = tmp .. "_FE" .. value .. ":\n\n"
   return ret .. tmp, i
end

function flatten()
   local l0, l1, l2 = label(), label(), label()
   local ret = prep(true) ..
      "\tcmpq\t$33, %rax\n" ..
      "\tjnz\t" .. l0 .. "\n" ..
      "\taddq\t$8, %rsp\n" ..
      "\tjmp\t" .. l1 .. "\n" ..
      l0 .. ":\tcmp\t$0, %rbx\n" ..
      "\tjz\t" .. l1 .. "\n" ..
      l2 .. ":\tcmpq\t$33, (%rbx)\n" ..
      "\tjz\t" .. l1 .. "\n" ..
      "\tpushq\t(%rbx)\n" ..
      "\tsubq\t$8, %rbx\n" ..
      "\tjmp\t" .. l2 .. "\n" ..
      l1 .. ":\tpushq\t$33\n"
   return ret
end

function develop()
   local lm, le, la, ln = label("_DM"), label("_DE"), label("_DA"), label("_DN")
   local l0, l1, l2, l3, l4, lg =
      label("_DV"), label("_DV"), label("_DV"), label("_DV"), label("_DV"), label("_DV")
   local ret =
      "# Comparison routine\n" ..
      "\tcmpq\t$33, %rax\n" ..
      "\tjnz\t" .. ln .. "\n" ..
      "\tdec\t%r15\n" ..
      "\tjmp\t" .. le .. "\n" ..
      ln .. ":\tcmpq\t$0, %rbx\n" ..
      "\tjz\t" .. le .. "\n" ..
      lm .. ":\tcmpq\t$33, (%rbx)\n" ..
      "\tjz\t" .. le .. "\n" ..
      "\tcmpq\t$1, %r15\n" ..
      "\tjz\t" .. l0 .. "\n" ..
      "\tcmpq\t$2, %r15\n" ..
      "\tjz\t" .. l1 .. "\n" ..
      "\tcmpq\t$3, %r15\n" ..
      "\tjz\t" .. l2 .. "\n" ..
      "\tcmpq\t$4, %r15\n" ..
      "\tjz\t" .. l3 .. "\n" ..
      "\tcmpq\t$5, %r15\n" ..
      "\tjz\t" .. l4 .. "\n" ..
      "\tjmp\t" .. lg .. "\n" ..
      l0 .. ":\tmovq\t(%rbx), %rsi\n" ..
      "\tjmp\t" .. la .. "\n" ..
      l1 .. ":\tmovq\t(%rbx), %rdx\n" ..
      "\tjmp\t" .. la .. "\n" ..
      l2 .. ":\tmovq\t(%rbx), %rcx\n" ..
      "\tjmp\t" .. la .. "\n" ..
      l3 .. ":\tmovq\t(%rbx), %r8\n" ..
      "\tjmp\t" .. la .. "\n" ..
      l4 .. ":\tmovq\t(%rbx), %r9\n" ..
      "\tjmp\t" .. la .. "\n" ..
      lg .. ":\tpushq\t(%rbx)\n" ..
      la .. ":\tsubq\t$8, %rbx\n" ..
      "\tinc\t%r15\n" ..
      "\tjmp\t" .. lm .. "\n" .. le .. ":"
   return ret
end

function params(text, i, p, call)
   local rs, rs2 = r_size
   local asm, tmp, typ = ""
   local pp = p - 6
   local func, alg
   local adjust
   if pp < 0 then pp = 0 end
   -- Protect
   ------------------------------
   asm = asm .. protect(false)
   rs2 = r_size
   -- Set the stack pointer
   ------------------------------
   if r_size > 1 then
      adjust = "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
   else
      adjust = "\tleaq\t(%rbp), %rsp\n"
   end
   if pp > 1 then
      r_size = r_size + pp
      if call then
	 r_size = r_size - 1
      end
   end
   alg = r_index
   align("%rdi")
   -- Get the parameters
   ------------------------------
   for j = 1, p do
      tmp, i, func = _translate(text, i, false, false)
      asm = asm .. tmp
   end
   typ, i = readline(text, i)
   
   if typ == "call" then
      asm = asm .. performcall(func, adjust, rs, rs2, p, pp, alg, call)
   elseif typ == "tcall" then
      asm = asm .. terminalcall(func, adjust, rs, rs2, p, pp, alg)
   end
   return asm, i
end

function fparams(text, i, p)
   local rs, rs2
   local asm, tmp, typ = ""
   local pp = p - 6
   local func, alg
   local adjust
   local v1, v2 = pop(), pop()
   push(v1)
   rs = r_size
   if pp < 0 then pp = 0 end
   -- Protect
   ------------------------------
   asm = asm .. protect(false)
   rs2 = r_size
   -- Set the stack pointer
   ------------------------------
   if r_size > 1 then
      adjust = "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
   else
      adjust = "\tleaq\t(%rbp), %rsp\n"
   end
   if pp > 1 then
      r_size = r_size + pp
      if call then
	 r_size = r_size - 1
      end
   end
   alg = r_index
   align("%rdi")
   -- Get the parameters
   ------------------------------
   asm = asm .. use()
   for j = 1, p do
      tmp, i, func = _translate(text, i, false, false)
      asm = asm .. tmp
   end
   typ, i = readline(text, i)
   -- call
   asm = asm .. performcall(func, adjust, rs, rs2, p + 1, pp, alg, call)
   return asm, i
end

function terminalcall(func, adjust, rs, rs2, p, pp, alg)
   local asm, t = ""
   for j = pp, 1, -1 do
      t = pop()
      if isMem(t) then
	 asm = asm .. "\tmovq\t" .. t.. ", %rax\n"
	 t = "%rax"
      elseif isDouble(t) then
	 asm = asm ..
	    "\tmovsd\t" .. t .. ", (%r12)\n" ..
	    "\tleaq\t6(, %r12, 8), %rax\n" ..
	    "\taddq\t$8, %r12\n"
	 t = "%rax"
      end
      asm = asm .. "\tmovq\t" .. t .. ", " .. j * 8 + 8 ..  "(%rbp)\n"
   end
   for j = 1, p do
      if j > 6 then break end
      t = pop()
      if t:sub(1, 1) ~= "%" or t == "%rax" then
	 asm = asm .. "\tmovq\t" .. t .. ", " .. future() .. "\n"
      end
      if isDouble(t) then
	 asm = asm ..
	    "\tmovsd\t" .. t .. ", (%r12)\n" ..
	    "\tleaq\t6(, %r12, 8), " .. future() .. "\n" ..
	    "\taddq\t$8, %r12\n"
      end
   end
   asm = asm .. "\tmovq\t$" .. p .. ", %r15\n"
   if func then asm = asm .. develop() end
   -- Restore
   ------------------------------
   r_size = rs2
   r_index = alg
   tmp = protect(rs)
   rsp = r_size - 1
   -- Terminal call
   ------------------------------
   local r = pop()
   if isMem(r) then
      asm = asm .. "\tmovq\t" .. r .. ", %rax\n"
      r = "%rax"
   end
   asm = asm ..
      "\tsarq\t$3, %rax\n" ..
      "\tmovq\t8(%rax), %r14\n" ..
      "\tleave\n" ..
      "\tjmpq\t*(" .. r .. ")\n"
   r_size = r_size - 1
   return asm .. tmp.. push("%rax")
end

function performcall(func, adjust, rs, rs2, p, pp, alg, call)
   local asm, t = ""
   ------------------------------ CALL
   if rsp ~= rs2 - 1 then
      asm = asm .. adjust
      rsp = rs2 - 1
   end
   if not call then
      asm = asm .. "\tpushq\t%r14\n"
   end
   for j = 1, pp do
      t = pop()
      if isDouble(t) then
	 asm = asm ..
	    "\tmovsd\t" .. t .. ", (%r12)\n" ..
	    "\tleaq\t6(, %r12, 8), %r15\n" ..
	    "\taddq\t$8, %r12\n"
	 t = "%r15"
      end
      asm = asm .. "\tpushq\t" .. t .. "\n"
   end
   for j = 1, p do
      if j > 6 then break end
      t = pop()
      if t:sub(1, 1) ~= "%" or t == "%rax" then
	 asm = asm .. "\tmovq\t" .. t .. ", " .. future() .. "\n"
      end
      if isDouble(t) then
	 asm = asm ..
	    "\tmovsd\t" .. t .. ", (%r12)\n" ..
	    "\tleaq\t6(, %r12, 8), " .. future() .. "\n" ..
	    "\taddq\t$8, %r12\n"
      end
   end
   if not call then
      asm = asm .. "\tmovq\t$" .. p .. ", %r15\n"
   end
   if func then asm = asm .. develop() end
   -- Restore
   ------------------------------
   r_size = rs2
   r_index = alg
   tmp = protect(rs)
   if r_size > 1 then
      tmp = tmp .. "\tleaq\t" .. -8 * (r_size - 1) .. "(%rbp), %rsp\n"
   else
      tmp = tmp .. "\tleaq\t(%rbp), %rsp\n"
   end
   rsp = r_size - 1
   -- Call
   ------------------------------
   if call then
      asm = asm ..
	 "\tpushq\t$33\n" ..
	 "\tandq\t$-16, %rsp\n" .. 
	 "\tcall\t" .. call .. "\n"
   else
      local r = pop()
      if isMem(r) then
	 asm = asm .. "\tmovq\t" .. r .. ", %rax\n"
	 r = "%rax"
      end
      asm = asm ..
	 "\tsarq\t$3, %rax\n" ..
	 "\tmovq\t8(%rax), %r14\n" ..
	 "\tcallq\t*(" .. r .. ")\n" ..
	 "\tpopq\t%r14\n"
   end
   return asm .. tmp.. push("%rax")
end

function chg(text, i, p)
   local asm, tmp = ""
   local rs, done = r_size
   for j = 1, p do
      tmp, i, done = _translate(text, i, true, false)
      if buf and isMem(buf) then
	 tmp = tmp .. lea(pop())
      end
      asm = asm .. tmp .. lock(pop())
   end
   tmp, i, done = _translate(text, i, true, false)
   if p == 0 then
      done = false
      while not (done == "stack") do
	 tmp, i, done = _translate(text, i, false, false)
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
   r_size = rs
   buf = nil
   return asm, i
end

function set(text, i, p)
   local asm, tmp = ""
   local func, j = false, 1
   local fill, r = false
   while j <= p do
      tmp, i, func = _translate(text, i, false, false)
      if func == "struct" then
	 tmp, i, func = _translate(text, i, false, false)
	 asm = asm .. tmp .. lock(pop())
	 if func then
	    asm = asm .. prep(true) ..
	       "\tleaq\t-8(%rsp), %r15\n"
	    fill = true
	 end
      else
	 asm = asm .. tmp .. lock(pop())
      end
      j = j + 1
   end
   if not func then
      r = true
   end
   tmp, i, func = _translate(text, i, false, false)
   if func == "done" then
      if r then
	 asm = asm .. prep(true) ..
	    "\tpushq\t$33\n"
      else
	 asm = asm .. flatten()
      end
   elseif fill then
      asm = asm .. prep(true) .. 
	 "\tcall\t_fill\n"
   end
   return asm, i
end

function ret(text, i, p)
   local asm, tmp = ""
   local r, base
   local struct
   local rs, vs = r_size, v_size
   if p == 1 then
      tmp, i, struct = _translate(text, i, false, false)
      asm = asm .. tmp
   else
      for j = 1, p do
	 tmp, i, struct = _translate(text, i, false, false)
	 asm = asm .. tmp .. lock(pop())
      end
   end
   if struct then
      local l1, l2 = label(), label()
      asm = asm .. flatten() ..
	 "\tleaq\t" .. -8 * rs .. "(%rbp), %rbx\n"
      r_size = rs
   elseif p > 1 then
      asm = asm .. "\tmovq\t$33, " ..  -8 * r_size .. "(%rbp)\n"..
	 "\tleaq\t" .. -8 * (rs + 1) .. "(%rbp), %rbx\n"
      r_size = rs
   else
      asm = asm .. "\txorq\t%rbx, %rbx\n"
   end
   r = pop()
   if isDouble(r) then
      asm = asm ..
	 "\tmovq\t" .. r .. ", (%r12)\n" ..
	 "\tleaq\t6(, %r12, 8), %rax\n" ..
	 "\taddq\t$8, %r12\n"
   elseif r ~= "%rax" then
      asm = asm .. "\tmovq\t" .. r .. ", %rax\n"
   end
   tmp, i = _translate(text, i, false, false)
   if rsp ~= 0 then
      asm = asm .. "\tleave\n\tret\n"
   else
      asm = asm .. "\tpopq\t%rbp\n\tret\n"
   end
   r_size, v_size = rs, vs
   return asm, i
end

---------- Parsing functions ----------
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

-- PROGRAM
--------------------------------------------------------------------------------
function translate(text)
   local ret, i = _translate(text, 1, false, false)
   ret = intro .. ret

   if i < #text then
      ret = ret .. func .. _translate(text, i, false, false)
   end
   
   if need_data then
      ret = ret .. data
   end
   return ret
end

function _translate(text, i, sets, loop)
   local asm, tmp = ""
   local s, i = readline(text, i)
   local instr, value
   local struct, vname = 0
   
   while s do
      instr, value = separate(s)
      --------------------
      if instr ~= "tac" then
	 struct = nil
      end
      if vname and instr ~= "params" then
	 push("$17")
	 vname = false
      end
      --------------------
      if instr == "num" then
	 asm = asm .. newdouble(tostring(tonumber(value)))

      elseif instr == "neg" then
	 asm = asm .. neg()
	 
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

      elseif instr == "ref" or instr == "arg" then
	 struct = instr == "arg"
	 tmp = tonumber(value) + 1
	 if ref_mask and tmp > ref_mask_low and tmp <= ref_mask_up then
	    tmp = tmp - ref_mask_low - 1
	    tmp = tostring(16 + 8 * tmp)
	 elseif ref_mask and tmp > ref_mask_up then
	    tmp = tmp - ref_mask_up + ref_mask_low
	    tmp = tostring(-8 * tmp)
	 elseif tmp > 0 then
	    tmp = tostring(-8 * tmp)
	 else
	    tmp = ""
	 end
	 if struct then
	    asm = asm .. push("%rax") ..
	       "\tmovq\t" .. tmp .. "(%rbp), %rax\n" ..
	       "\tsarq\t$3, %rax\n" ..
	       "\tleaq\t-8(%rax), %rbx\n" ..
	       "\tmovq\t(%rax), %rax\n"
	 else
	    asm = asm .. push(tmp .. "(%rbp)")
	 end

      elseif instr == "clo" then
	 asm = asm .. clo(sets, value)

      elseif instr == "encl" then
	 asm = asm .. encl(value)

      elseif instr == "open" then
	 asm = asm .. prep(true) ..
	    "\tmovq\t$" .. value .. ", %rax\n" ..
	    "\tcall\t_open\n"

      elseif instr == "gbl" then
	 asm = asm .. index(sets, value)
	 
      elseif instr == "var" then
	 vname = value

      elseif instr == "trunc" then
	 asm = asm .. "\txorq\t%rbx, %rbx\n"

      elseif instr == "add" or
	 instr == "sub" or
	 instr == "mul" or
	 instr == "div"
      then
	 asm = asm .. flt(instr)

      elseif instr == "pow" then
	 asm = asm .. pow()

      elseif
	 instr == "bshr" or
	 instr == "bsar" or
	 instr == "bsal" or
	 instr == "band" or
	 instr == "bor"  or
	 instr == "bxor"
      then
	 asm = asm .. bits(instr:sub(2, #instr), false)

      elseif instr == "binv" then
	 asm = asm .. inv()

      elseif instr == "beq" then
	 asm = asm .. eq(true)
      elseif instr == "bneq" then
	 asm = asm .. eq(false)

      elseif instr == "idiv" then
	 asm = asm .. flt("div")
	 asm = asm .. "\troundsd\t$3, " .. get() .. ", " .. get() .. "\n"

      elseif instr == "eq" then
	 asm = asm .. opcall2("compare")
	 
      elseif
	 instr == "lt"  or
	 instr == "lte" or
	 instr == "gt"  or
	 instr == "gte" or
	 instr == "neq" 
      then
	 asm = asm .. opcall2(instr)

      elseif instr == "and" or instr == "or" then
	 tmp, i = bool(instr, value, text, i)
	 asm = asm .. tmp

      elseif instr == "con" then
	 asm = asm .. opcall2("concat")

      elseif instr == "mod" then
	 asm = asm .. mod()
	 --asm = asm .. imod()
	 
      elseif instr == "not" then
	 asm = asm .. nt()

      elseif instr == "len" then
	 asm = asm .. len()

      elseif instr == "init" then
	 tmp, i = init(text, i, tonumber(value))
	 asm = asm .. tmp

      elseif instr == "index" then
	 asm = asm .. index(sets, false)

      elseif instr == "findex" then
	 asm = asm .. findex()
	 
      elseif instr == "new" then
	 asm = asm .. new()

      elseif instr == "append" then
	 asm = asm .. append()

      elseif instr == "setsize" then
	 asm = asm .. setsize()

      elseif instr == "put" then
	 asm = asm .. put()

      elseif instr == "fparams" then
	 tmp, i = fparams(text, i, tonumber(value))
	 struct = true
	 asm = asm .. tmp
	 
      elseif instr == "params" then
	 tmp, i = params(text, i, tonumber(value), vname)
	 vname = false
	 struct = true
	 asm = asm .. tmp
	 
      elseif instr == "chg" then
	 tmp, i = chg(text, i, tonumber(value))
	 asm = asm .. tmp
	 
      elseif instr == "set" then
	 tmp, i = set(text, i, tonumber(value))
	 asm = asm .. tmp

      elseif instr == "ret" then
	 tmp, i = ret(text, i, tonumber(value))
	 asm = asm .. tmp

      elseif instr == "rfct" then
	 asm = asm .. use() ..
	    "\tleaq\t_FN" .. value .. "(%rip), " .. current() .. "\n" ..
	    "\tmovq\t" .. current() .. ", (%r12)\n" ..
	    "\tmovq\t%r14, 8(%r12)\n" ..
	    "\tleaq\t7(, %r12, 8), " .. current() .. "\n" ..
	    "\taddq\t$16, %r12\n"

      elseif instr == "if" then
	 tmp, i = ifenv(text, i, value, loop)
	 asm = asm .. tmp

      elseif instr == "while" then
	 tmp, i = whenv(text, i, value)
	 asm = asm .. tmp

      elseif instr == "repeat" then
	 tmp, i = rpenv(text, i, value)
	 asm = asm .. tmp

      elseif instr == "for" then
	 tmp, i = frenv(text, i, value)
	 asm = asm .. tmp

      elseif instr == "forin" then
	 tmp, i = fienv(text, i, value)
	 asm = asm .. tmp

      elseif instr == "fct" then
	 tmp, i = fct(text, i, value)
	 asm = asm .. tmp

      elseif instr == "free" then
	 r_size = r_size - tonumber(value)

      elseif
	 instr == "stack"  or
	 instr == "place"  or
	 instr == "done"   or
	 instr == "struct" or
         instr == "wdo"    or
	 instr == "wend"   or
         instr == "until"  or
	 instr == "rend"   or
	 instr == "frdo"   or
	 instr == "frend"  or
	 instr == "fido"   or
	 instr == "fiend"  or
         instr == "then"   or
         instr == "else"   or
	 instr == "iend"   or
	 instr == "call"   or
	 instr == "tcall"
      then
	 return asm, i, instr

      elseif instr == "brk" then
	 asm = asm ..
	    "\tjmp\t" .. loop .. "\n"
	 rsp = 0

      elseif instr == "tac" then
	 return asm, i, struct

      elseif instr == "fend" then
	 if asm:sub(#asm - 3, #asm) ~= "ret\n" then
	    asm = asm .. "\tmovq\t$33, %rax\n"
	    if rsp ~= 0 then
	       asm = asm .. "\tleave\n\tret\n"
	    else
	       asm = asm .. "\tpopq\t%rbp\n\tret\n"
	    end
	 else
	    asm = asm .. "\n"
	 end
	 return asm, i

      elseif instr == "exit" then
	 if rsp ~= 0 then
	    asm = asm .. "\tleave\n"
	 else
	    asm = asm .. "\tpopq\t%rbp\n"
	 end
	 return asm .. outro, i
      end
      --------------------
      s, i = readline(text, i)
   end
   return asm
end

---------- MAIN ----------
comp_code = translate(comp_code)

local file
file = io.open(comp_target .. ".s", "w+")
file:write(comp_code)
file:close()

--[[
INTEGER FUNCTIONS ## DEPRECATED ##
function idiv(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if u_cont[1] and v2 ~= "%rdx" then
      ret = "\tmovq\t%rdx, %r15\n"
   end
   if v1:sub(1, 1) == "$" then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rbx\n"
      v1 = "%rbx"
   end
   ret = ret .. 
      "\tmovq\t" .. v2 .. ", " .. "%rax\n" ..
      "\tcdq\n" ..
      "\tidivq\t" .. v1 .. "\n" ..
      "\tmovq\t%rax, " .. v2 .. "\n"      
   if u_cont[1] and v2 ~= "%rdx" then
      ret = ret .. "\tmovq\t%r15, %rdx\n"
   end
   return ret
end

function imod(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if u_cont[1] and v2 ~= "%rdx" then
      ret = "\tmovq\t%rdx, %r15\n"
   end
   if v1:sub(1, 1) == "$" then
      ret = ret ..
	 "\tmovq\t" .. v1 .. ", %rbx\n"
      v1 = "%rbx"
   end
   ret = ret ..
      "\tmovq\t" .. v2 .. ", " .. "%rax\n" ..
      "\tcdq\n" ..
      "\tidivq\t" .. v1 .. "\n" ..
      "\tmovq\t%rdx, " .. v2 .. "\n"      
   if u_cont[1] and v2 ~= "%rdx" then
      ret = ret .. "\tmovq\t%r15, %rdx\n"
   end
   return ret
end

function num(op)
   local ret = ""
   local v1 = pop()
   local v2 = get()
   if isMem(v1) and isMem(v2) then
      ret = "\tmovq\t" .. v2 .. ", " .. promote() .. "\n"
      v2 = current()
   end
   ret = ret .. "\t" .. op .. "\t" .. v1 .. ", " .. v2 .. "\n"
   return ret
end
]]
