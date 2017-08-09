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
u_name = { "%rdx", "%rcx", "%r8" , "%r9" , "%r10", "%r11", "%rdi", "%rsi" }
u_cont = { false , false , false , false , false , false , false , false  }

-- Calling registers (6)
c_size = 6
c_name = { "%rdi", "%rsi", "%rdx", "%rcx", "%r8" , "%r9"  }

-- Double-precision registers (16)
d_size = 12
d_name = { "%xmm4" , "%xmm5" , "%xmm6" , "%xmm7" , "%xmm8" , "%xmm9" ,
	   "%xmm10", "%xmm11", "%xmm12", "%xmm13", "%xmm14", "%xmm15" }
d_cont = { false   , false   , false   , false   , false   , false   ,
	   false   , false   , false   , false   , false   , false    }

rsp = 0

str_tbl = {}

ref_mask = false

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
   "\tmovq\t$17, %r14\n" ..
   "\n# GENERATED CODE BEGINING" ..	    
   "\n################################################################################\n\n"

func = "\n# FUNCTIONS" ..	    
   "\n################################################################################\n\n"

need_data = false
data = "\n# DATA" ..	    
   "\n################################################################################\n\n" ..
   "\t.data\n\n"

outro =
   "\tpopq\t%r15\n" ..
   "\tpopq\t%r14\n" ..
   "\tpopq\t%r13\n" ..
   "\tpopq\t%r12\n" ..
   "\tpopq\t%rbx\n" ..
   "\tmovq\t$0, %rax\n" ..
   "\tret\n"

-- Internal stack structure
--------------------------------------------------------------------------------
buf = false

f_size  = 0

v_stack = {}
v_size  = 0

r_size  = 1

r_index = 1

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

---------- EXTERNAL ----------
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
      ret = "#" .. tostring(-8 * r_size) .. "(%rbp)\t" .. tostring(u_cont[1]) .."\n"
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
      ret = "\tmovq\t" .. v2 .. ", " .. promote() .. "\n"
      v2 = current()
   end
   ret = ret .. "\t" .. op .. "\t" .. v1 .. ", " .. v2 .. "\n"
   return ret
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

function leq()
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
   ret = prep(true) ..
      "\tmovq\t" .. v1 .. ", %rax\n" ..
      "\tsarq\t$3, %rax\n" ..
      "\tcmpq\t$65, (%rax)\n" ..
      "\tjnz\t" .. lab .. "\n" ..
      "\tcall\t_check\n" ..
      lab .. ":" ..
      "\tcvtsi2sd\t(%rax), %xmm0\n" ..
      newdouble("%xmm0")
   return ret
end

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
	 ret = "\tmovq\t" .. vd .. ", (%r12)\n" ..
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

function ifenv(text, i, p)
   local ret, tmp1, tmp2 = "_IF" .. p .. ":\n"
   local tag, jlab, v
   local vs, rs
   tmp1, i = _translate(text, i, false)
   v = pop()
   --vs, rs = v_size, r_size
   tmp2, i, tag = _translate(text, i, false)
   if tag == "else" then
      jlab = "_EL" .. p
   else
      jlab = "_FI" .. p
   end
   if v:sub(1, 1) == "$" then
      tmp = tmp .. "\tmovq\t" .. v .. ", %rax\n"
      v = "%rax"
   end
   ret = ret .. tmp1 .. "_TH" .. p .. ":\n" ..
      "\tcmpq\t$1, " .. v .. "\n" ..
      "\tjz\t" .. jlab .. "\n" ..
      "\tcmpq\t$17, " .. v .. "\n" ..
      "\tjz\t" .. jlab .. "\n" ..
      tmp2
   if tag == "else" then
      --v_size, r_size = vs, rs
      tmp1, i = _translate(text, i, false)
      ret = ret ..
	 "\tjmp\t_FI" .. p .. "\n" .. jlab .. ":\n" ..
	 tmp1 .. "_FI" .. p .. ":\n"
   else
      ret = ret .. jlab .. ":\n"
   end
   return ret, i
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

function build(nargs, varargs, fname)
   local ret = ""
   local p = 1
   ret = 
      "\tmovq\t$" .. nargs .. ", %rax\n" ..
      "\tcall\t_nil_fill\n"
   if varargs then
      ret = ret ..
	 "\tcall\t_varargs\n"
      if nargs <= 6 then
	 ret = ret .. "\tmovq\t%r15, " .. c_name[nargs] .. "\n"
      elseif nargs == 0 then
	 ret = ret .. "\tmovq\t%r15, %rdi\n"
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
   local ret, i = _translate(text, 1, false)
   ret = intro .. ret

   if i < #text then
      ret = ret .. func .. _translate(text, i, false)
   end
   
   if need_data then
      ret = ret .. data
   end
   return ret
end

function _translate(text, i, sets)
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
      --------------------
      if instr == "num" then
	 asm = asm .. newdouble(tostring(tonumber(value)))

      elseif instr == "neg" then
	 tmp = get()
	 asm = asm ..
	    "\tmovsd\t" .. tmp .. ", (%r12)\n" ..
	    "\txorpd\t" .. tmp .. ", " .. tmp .. "\n" ..
	    "\tsubsd\t(%r12), " .. tmp .. "\n"
	 
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
	 --asm = asm .. var(value)

      elseif instr == "add" or
	 instr == "sub" or
	 instr == "mul" or
	 instr == "div"
      then
	 asm = asm .. flt(instr)

      elseif instr == "mod" then
	 --tmp
	 asm = asm .. imod()

      elseif instr == "not" then
	 asm = asm .. nt()
	 
      elseif instr == "eq" then
	 asm = asm .. eq()

      elseif instr == "leq" then
	 asm = asm .. leq()

      elseif instr == "len" then
	 asm = asm .. len()

      elseif instr == "init" then
	 tmp, i = init(text, i, tonumber(value))
	 asm = asm .. tmp

      elseif instr == "index" then
	 asm = asm .. index(sets, false)
	 

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
	 tmp, i = ifenv(text, i, value)
	 asm = asm .. tmp

      elseif instr == "fct" then
	 tmp, i = fct(text, i, value)
	 asm = asm .. tmp
	 
      elseif instr == "call" or instr == "tcall" then
	 return asm, i

      elseif instr == "free" then
	 r_size = r_size - tonumber(value)

      elseif
	 instr == "stack" or
	 instr == "place" or
	 instr == "done" or
	 instr == "struct"
      then
	 return asm, i, instr

      elseif
         instr == "then" or
         instr == "else" or
	 instr == "iend"
      then
	 return asm, i, instr

      elseif instr == "tac" then
	 return asm, i, struct

      elseif instr == "fend" then
	 if asm:sub(#asm - 3, #asm) ~= "ret\n" then
	    asm = asm .. "\tmovq\t$17, %rax\n"
	    if rsp ~= 0 then
	       asm = asm .. "\tleave\n\tret\n\n"
	    else
	       asm = asm .. "\tpopq\t%rbp\n\tret\n\n"
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
   
   tmp, i = _translate(text, i, false)
   return ret .. tmp, i
end

function develop()
   local lm, le, la = label("_DM"), label("_DE"), label("_DA")
   local l1, l2, l3, l4, lg = label("_DV"), label("_DV"), label("_DV"), label("_DV"), label("_DV")
   local ret =
      "# Comparison routine\n" ..
      "\tcmpq\t$0, %rbx\n" ..
      "\tjz\t" .. le .. "\n" ..
      "\tmovq\t(%rbx), %rsi\n" ..
      "\tjmp\t" .. la .. "\n" ..
      lm .. ":\tcmpq\t$33, (%rbx)\n" ..
      "\tjz\t" .. le .. "\n" ..
      "\tcmpq\t$2, %r15\n" ..
      "\tjz\t" .. l1 .. "\n" ..
      "\tcmpq\t$3, %r15\n" ..
      "\tjz\t" .. l2 .. "\n" ..
      "\tcmpq\t$4, %r15\n" ..
      "\tjz\t" .. l3 .. "\n" ..
      "\tcmpq\t$5, %r15\n" ..
      "\tjz\t" .. l4 .. "\n" ..
      "\tjmp\t" .. lg .. "\n" ..
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

---------- MEMORY SETTING ----------
function params(text, i, p, call)
   local rs, rs2 = r_size
   local asm, tmp, typ = ""
   local pp = p - 6
   local func, alg
   local adjust
   if pp < 0 then pp = 0 end
   -- Protect
   ------------------------------
   if buf then
      asm = asm .. lock(pop())
   end
   for j = v_size, v_size - u_size, -1 do
      if j == 0 then break end
      asm = asm .. lock(pop())
   end
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
      tmp, i, func = _translate(text, i, false)
      asm = asm .. tmp
   end
   typ, i = readline(text, i)
   ------------------------------ CALL
   if typ == "call" then
      if rsp ~= rs2 - 1 then
	 asm = asm .. adjust
	 rsp = rs2 - 1
      end
      if not call then
	 asm = asm .. "\tpushq\t%r14\n"
      end
      local t
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
      tmp = ""
      r_size = rs2
      r_index = alg
      for j = r_size - 1, rs, -1 do
	 tmp = tmp .. unlock()
      end
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
	    "\tsubq\t$16, %rsp\n" ..
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
      return asm .. tmp.. push("%rax"), i
      ------------------------------ TCALL
   elseif typ == "tcall" then
      local t
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
      if not call then
	 asm = asm .. "\tmovq\t$" .. p .. ", %r15\n"
      end
      if func then asm = asm .. develop() end
      -- Restore
      ------------------------------
      tmp = ""
      r_size = rs2
      r_index = alg
      for j = r_size - 1, rs, -1 do
	 tmp = tmp .. unlock()
      end
      rsp = r_size - 1
      -- Terminal call
      ------------------------------
      if call then
	 asm = asm ..
	    "\tleave\n" ..
	    "\tjmp\t" .. call .. "\n"
      else
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
      end
      return asm .. tmp.. push("%rax"), i
   end
end

function chg(text, i, p)
   local asm, tmp = ""
   local rs, done = r_size
   for j = 1, p do
      tmp, i, done = _translate(text, i, true)
      if buf and isMem(buf) then
	 tmp = tmp .. lea(pop())
      end
      asm = asm .. tmp .. lock(pop())
   end
   tmp, i, done = _translate(text, i, true)
   if p == 0 then
      done = false
      while not (done == "stack") do
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
   r_size = rs
   buf = nil
   return asm, i
end

function set(text, i, p)
   local asm, tmp = ""
   local func, j = false, 1
   local fill, r = false
   while j <= p do
      tmp, i, func = _translate(text, i, false)
      if func == "struct" then
	 tmp, i, func = _translate(text, i, false)
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
   tmp, i, func = _translate(text, i, false)
   if func == "done" then
      if r then
	 asm = asm .. prep(true) ..
	    "\tpushq\t$33\n"
      else
	 local l1, l2 = label(), label()
	 asm = asm .. prep(true) ..
	    --"\taddq\t$16, %rsp\n" ..
	    "\tcmp\t$0, %rbx\n" ..
	    "\tjz\t" .. l1 .. "\n" ..
	    l2 .. ":\tcmpq\t$33, (%rbx)\n" ..
	    "\tjz\t" .. l1 .. "\n" ..
	    "\tpushq\t(%rbx)\n" ..
	    "\tsubq\t$8, %rbx\n" ..
	    "\tjmp\t" .. l2 .. "\n" ..
	    l1 .. ":\tpushq\t$33\n"
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
   ---- CANNOT RETURN MEMORY, WILL HAVE TO USE STACK
   tmp, i = _translate(text, i, false)
   asm = tmp .. lock(pop())
   base = r_size
   for j = 2, p do
      tmp, i, struct = _translate(text, i, false)
      asm = asm .. tmp .. lock(pop())
   end
   if p > 1 then
      local l1, l2 = label(), label()
      asm = asm .. prep(true)
      if struct then
	 asm = asm ..
	    "\tcmp\t$0, %rbx\n" ..
	    "\tjz\t" .. l1 .. "\n" ..
	    l2 .. ":\tcmpq\t$33, (%rbx)\n" ..
	    "\tjz\t" .. l1 .. "\n" ..
	    "\tpushq\t(%rbx)\n" ..
	    "\tsubq\t$8, %rbx\n" ..
	    "\tjmp\t" .. l2 .. "\n" ..
	    l1 .. ":\tpushq\t$33\n"
      else
	 asm = asm .. "\tpushq\t$33\n"
      end
      r_size = base
      asm = asm ..
	 "\tleaq\t" .. pop() .. ", %rbx\n" ..
	 "\tmovq\t" .. pop() .. ", %rax\n"
   else
      r_size = base - 1
      asm = asm ..
	 "\txorq\t%rbx, %rbx\n" ..
	 "\tmovq\t" .. pop() .. ", %rax\n"
   end
   tmp, i = _translate(text, i, false)
   if rsp ~= 0 then
      asm = asm .. "\tleave\n\tret\n"
   else
      asm = asm .. "\tpopq\t%rbp\n\tret\n"
   end
   return asm, i
end

---------- MAIN ----------
local file = io.open(comp_file .. ".lir", "r")
text = file:read("all")
file:close()
file = io.open(comp_file .. ".s", "w+")
file:write(translate(text))
file:close()
