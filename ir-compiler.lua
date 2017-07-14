-- Register information
--------------------------------------------------------------------------------
-- Registers (16)
r = { "%rax", "%rbx", "%rcx", "%rdx", "%rbp", "%rsp", "%rsi", "%rdi",
      "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }

-- Reserved: %rax, %rbx, %rsp, %rbp

-- Usable registers (6)
u_reg  = 1
u_size = 6
u_name = { "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }
u_cont = {  0,      0,      0,      0,      0,      0     }

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
   "\txor\t%rbx, %rbx\n" ..
   "\tmov\t$134217728, %rax\n" ..
   --"\tmov\t%rax, _mem_size(%rip)\n" ..
   "\tpush\t%rax\n" ..
   "\tcall\tmmap\n" ..
   "\tmov\t%rax, %rbp\n" ..
   "\tmov\t%rbp, %rbx\n" ..
   "\tadd\t$16, %rbp\n" ..
   "\tmovq\t$0, (%rbx)\n" ..
   "\tmovq\t$17, 8(%rbx)\n" ..
   "\tlea\t3(, %rbx, 8), %rbx\n"
   --"\tmov\t%rbp, _mem_base(%rip)\n" ..
   --"\tmov\t%rsp, _stack_base(%rip)\n"

outro =
   "\tmov\t$0, %rax\n" ..
   "\tret\n"

need_data = false
data = "\n# DATA" ..	    
   "\n################################################################################\n" ..
   ".data\n\n"

variables = {}

-- Internal structures and functions
--------------------------------------------------------------------------------
buf = false

vstack = {}
vsize  = 0

rstack = {}
rsize = 0
-----------------------------------------
function vpush(value)
   vsize = vsize + 1
   vstack[vsize] = value
end

function vpop()
   local tmp = vstack[vsize]
   vstack[vsize] = nil
   vsize = vsize - 1
   --tmp
   if vsize < 0 then
      print("ERROR")
   end
   return tmp
end

function vtop()
   return vstack[vsize]
end

function vat(index)
   return vstack[vsize - index]
end

function vfree(index)
   index = vsize - index
   for i = index + 1, vsize do
      vstack[i] = nil
   end
   vsize = index
end

function realsize()
   if buf then
      return vsize + 1
   end
   return vsize
end

function flatten()
   if buf then
      if available() then
	 ret = "\tmov\t" .. buf .. ", " .. register() .. "\n"
      else
	 ret = replace()
	 ret = ret .. "\tmov\t" .. buf .. ", " .. register() .. "\n"
      end
      vpush(current())
      buf = false
      return ret
   end
   return ""
end

function fillbuf()
   if not buf then
      buf = vstack[vsize]
      vstack[vsize] = nil
      vsize = vsize - 1
   end
end


function rpush(value)
   rsize = rsize + 1
   rstack[rsize] = value
end

function rpop()
   local tmp = rstack[rsize]
   rstack[rsize] = nil
   rsize = rsize - 1
   return tmp
end

function rtop()
   return rstack[rsize]
end

function rat(index)
   return rstack[index]
end

function rfree(index)
   index = rsize - index
   for i = index + 1, rsize do
      rstack[i] = nil
   end
   rsize = index
end

-- Register handling functions
--------------------------------------------------------------------------------
function available()
   return u_cont[u_reg] == 0
end

function register()
   u_cont[u_reg] = u_cont[u_reg] + 1
   u_reg = u_reg % u_size + 1
   return u_name[(u_reg - 2) % u_size + 1]
end

function current()
   return u_name[(u_reg - 2) % u_size + 1]
end

function future()
   return u_name[u_reg]
end

function release()
   u_reg = (u_reg - 2) % u_size + 1
   u_cont[u_reg] = u_cont[u_reg] - 1
   return u_name[u_reg]
end

function replace()
   local n = u_name[u_reg]
   rpush(n)
   for i = 1, vsize do
      if vstack[i] == n then
	 vstack[i] = rsize
      end
   end
   u_cont[u_reg] = 0
   return "\tpush\t" .. n .. "\n"
end

-- *** Operating functions ***
--------------------------------------------------------------------------------
function realpush()
   local ret = ""
   if buf then
      ret = "\tpush\t" .. buf .. "\n"
      rpush(register())
      vpush(rsize)
      buf = false
   else
      rpush(vtop())
      ret = "\tpush\t" .. vtop() .. "\n"
      vstack[vsize] = rsize
   end
   return ret
end

function push(value, ...)
   local ret = ""
   if buf then
      if type(vtop()) == "number" and buf:sub(#buf, #buf) == ")" then
	 ret = "\tmov\t" .. buf .. ", %rax\n"
	 buf = "%rax"
      end
      if not available() then
	 ret = ret .. replace()
      end
      ret = ret .. "\tmov\t" .. buf .. ", " .. register() .. "\n"
      vpush(current())
   end
   if arg[1] and value then
      buf = value
   elseif value then
      if not available() then
	 ret = ret .. replace()
      end
      ret = ret .. "\tmov\t" .. value .. ", " .. register() .. "\n"
      vpush(current())
   else
      vpush(register())
   end
   return ret
end

function promote(index)
   local ret, swap = "", false
   local virtual, real = get(index)
   if type(virtual) == "number" then
      real = rstack[virtual]
      for i = 1, vsize do
	 if vstack[i] == real then
	    swap = i
	 end
      end
      if swap then
	 vstack[i] = virtual
	 local tmp = rsize - virtual
	 if tmp > 0 then
	    tmp = tostring(8 * tmp)
	 else
	    tmp = ""
	 end
	 ret = "\txchg\t" .. tmp .. "(%rsp), " .. real .. "\n"
      elseif virtual == rsize then
	 ret = "\tpop\t" .. real .. "\n"
	 rpop()
      else
	 local tmp = rsize - virtual
	 if tmp > 0 then
	    tmp = tostring(8 * tmp)
	 else
	    tmp = ""
	 end
	 ret = "\tmov\t" .. tmp .. "(%rsp), " .. real .. "\n"
      end
      set(index, real)
   end
   return ret
end

function realpop()
   local ret = ""
   if rsize > 0 then
      local doable = true
      for i = 1, vsize do
	 if vstack[i] == rtop() then
	    doable = false
	 end
      end
      if doable then
	 for i = 1, vsize do
	    if vstack[i] == rsize then
	       vstack[i] = rtop()
	    end
	 end
      end
      ret = "\tpop\t" .. rtop() .. "\n"
      rpop()
   end
   return ret
end

function pop()
   if buf then
      local tmp = buf
      buf = false
      return tmp
   end
   release()
   return vpop()
end

function popin()
   if buf then return "" end
   local ret = promote(0)
   buf = vpop()
   release()
   return ret
end

function free(index)
   --local ret = rearrange()
   if index == 0 then return ""
   end
   if buf then
      buf = false
      index = index - 1
      if index == 0 then return "" end
   end
   for i = vsize - index + 1, vsize do
      release()
      vstack[i] = nil
   end
   vsize = vsize - index
   return restore()
end

function rearrange()
   local i, ret = vsize, ""
   while i >= 1 do
      if type(vstack[i]) == "number" then
	 if vstack[i] > rsize then
	    vstack[i] = u_name[u_reg % 8]
	 elseif vstack[i] == rsize then
	    ret = "\tpop\t" .. rtop() .. "\n"
	    rpop()
	 else
	    ret = "\tmov\t" .. tostring(8 * (rsize - vstack[i])) .. ", " .. rstack[vstack[i]] .. "\n"
	 end
	 vstack[i] = rstack[i]
      end
   i = i - 1
   end
   return ret
end

function restore()
   local max, ret = 0, ""
   if (vsize + 1) % u_size ~= u_reg then
      print("Possible stack corruption")
   end
   for i = 1, vsize do
      if type(vstack[i]) == "number" then
	 if vstack[i] > rsize then
	    vstack[i] = u_name[i % 8]
	 elseif vstack[i] > max then
	    max = vstack[i]
	 end
      end
   end
   for i = max + 1, rsize do
      rstack[i] = nil
   end
   if rsize - max ~= 0 and rsize > 0 then
      ret = "\tadd\t$" .. tostring((rsize - max) * 8) .. ", %rsp\n"
   end
   rsize = max
   return ret
end

function get(index)
   if buf then
      if index == 0 then
	 return buf
      else
	 index = index - 1
      end
   end
   local val = vat(index)
   if type(val) == "string" then
      return val
   else
      local num = 8 * (rsize - val)
      if num == 0 then
	 num = ""
      else
	 num = tostring(num)
      end
      return num .. "(%rsp)"
   end
end

function set(index, value)
   if buf then
      if index == 0 then
	 buf = value
      else
	 index = index - 1
      end
   end
   vstack[vsize - index] = value
end

function op2(op)
   local ret = popin() ..
      "\t" .. op .. "\t" .. buf .. ", " .. get(1) .. "\n"
   buf = false
   return ret
end

function mul()
   local ret = popin() ..
      "\timul\t" .. buf .. ", " .. get(1) .. "\n" ..
      "\tsar\t$3, " .. get(1) .. "\n"
   buf = false
   return ret
end

function neg()
   local ret = ""
   if buf then
      ret = "\tmov\t" .. buf .. ", %rax\n" ..
	 "\tneg\t%rax\n"
      buf = "%rax"
   else
      ret = "\tneg\t" .. get(0) .. "\n"
   end
   return ret
end

function eq()
   local ret = popin() ..
      "\tmov\t" .. buf .. ", %rax\n" .. 
      "\tmov\t" .. get(1) .. ", %rcx\n" ..
      "\tcall\tcompare\n" ..
      "\tmov\t%rax, " .. get(1) .. "\n"
   buf = false
   return ret
end

function var(value)
   local ret = ""
   ------- PRIMITIVES -------
   if value == "_print" then
      ret = ret .. "\tpush\t" .. get(0) .. "\n" ..
	 "\tcall\tprint_lua\n\tcall\tprint_ret\n"
      vpush(register())
   --------------------------
   else
      if not variables[value] then
	 variables[value] = tostring(#variables)
      end
      if buf then
	 ret = flatten()
      end
      ret = ret ..
	 "\tmov\t$" .. variables[value] .. ", %rax\n" ..
	 "\tcall\tvar\n" ..
	 push("(%rax)", true)
   end
   return ret
end

function index(new)
   local ret = popin() ..
      "\tmov\t" .. buf .. ", %rax\n" .. 
      "\tmov\t" .. get(1) .. ", %rcx\n"
   if new then
      ret = ret .. "\tcall\tnew\n"
   else
      ret = ret .. "\tcall\tindex\n"
   end
   --ret = ret .. realpop()
   buf = false
   pop()
   buf = "(%rax)"
   return ret
end

function check()
   local ret = popin() ..
      "\tmov\t" .. buf .. ", %rax\n" .. 
      "\tcall\tcheck\n"
   buf = false
   return ret
end

function len()
   local ret = ""
   if buf then
      if buf ~= "%rax" then
	 ret = "\tmov\t" .. buf .. ", %rax\n"
      end
      ret = ret ..
	 "\tsar\t$3, %rax\n" ..
	 "\tmov\t(%rax), %rax\n"
      buf = "%rax"
   else
      ret = popin() .. 
	 "\tsar\t$3, " .. buf .. "\n" ..
	 "\tmov\t(" .. buf .. "), " .. buf .. "\n"
   end
   return ret
end

function nt()
   local ret, addr = "", tostring(notcount)
   if buf then
      ret = flatten()
   end
   ret = ret ..
      "\tmov\t" .. get(0) .. ", %rax\n" ..
      "\tcall\tnot\n" ..
      "\tmov\t%rax, " .. get(0) .. "\n"
   return ret
end

stringcount = 0
function st(value)
   local ret = flatten()
   need_data = true
   stringcount = stringcount + 1
   data = data .. "string" .. tostring(stringcount) .. ":\n" ..
      "\t.quad\t" .. tostring((#value - 2) * 8) .. "\n" ..
      "\t.asciz\t" .. value .. "\n"
   vpush(register())
   return ret .. "\tlea\tstring" .. tostring(stringcount) .. "(%rip), " .. vtop() .. "\n" ..
      "\tlea\t2(, " .. vtop() .. ", 8), " .. vtop() .. "\n"
end

function concat()
   local ret, reg, mov = "", "", ""
   ret = popin()
   if buf:sub(#buf, #buf) == ")" then
      ret = ret .. "\tmov\t" .. buf .. ", %rax\n"
      buf = "%rax"
   end
   rpush("%rcx")
   ret = ret ..
      "\tmovq\t$4, (%rbp)\n" ..
      "\tmovq\t" .. buf .. ", 8(%rbp)\n" ..
      "\tmovq\t$17, 16(%rbp)\n" ..
      "\tlea\t4(, %rbp, 8), %rcx\n" ..
      "\tmov\t%rcx, (" .. get(1) .. ")\n" ..
      "\tlea\t16(%rbp), " .. get(1) .. "\n" ..
      "\tadd\t$24, %rbp\n"
   rpop()
   buf = false
   return ret
end

function gen(size)
   local i = 1
   while i <= size + 1 do
      push(false)
      i = i + 1
   end
end

ident = 0
function prepandret(args)
   ident = ident + 1
   local i, ret = 1
   ret =
      "\tpush\t%r10\n" .. 
      "\tpush\t%r11\n" ..
      "\tpush\t%r12\n" ..
      "\tpush\t%r13\n" ..
      "\tpush\t%r14\n" .. 
      "\tpush\t%r15\n" ..
      "\tpush\treturn" .. tostring(ident) .. "(%rip)\n"
   while i <= c_size and i <= args do
      ret = ret .. "\tmov\t" .. get(0) .. ", " .. c_name[i] .. "\n"
      pop()
      i = i + 1
   end
   while i <= args do
      ret = ret .. push(get(0))
      pop()
      i = i + 1
   end
   ret = ret ..
      "\tmov\t$" .. tostring(args) .. ", %rax\n" ..
      "\tsar\t$3, " .. get(0) .. "\n" ..
      "\tjmp\t*" .. get(0) .. "\n" ..
      "return" .. ident .. ":\n" ..
      "\tpop\t%r15\n" .. 
      "\tpop\t%r14\n" ..
      "\tpop\t%r13\n" ..
      "\tpop\t%r12\n" ..
      "\tpop\t%r11\n" .. 
      "\tpop\t%r10\n"
   return ret
end

-- Parsing functions
--------------------------------------------------------------------------------
function readline(str, i)
   if i > #str then
      return false, i
   end
   local s, ret = str:sub(i, i), ""
   while s ~= "\n" and i <= #str do
      ret = ret .. s
      i = i + 1
      s = str:sub(i, i)
   end
   return ret, i + 1
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
   local ret = intro
   local s, i = readline(text, 1)
   local instr, value
   local sets = false
   local modif, target, funcs, args = false, false, false
   local elses = {}
   while s do
      instr, value = separate(s)
      ---------------------------
      if instr == "nil" then
	 ret = ret .. push("$17", true)
	 
      elseif instr == "int" then
	 value = 8 * tonumber(value)
	 ret = ret .. push("$" .. tostring(value), true)
	 
      elseif instr == "bool" then
	 if value == "true" then
	    ret = ret .. push("$9", true)
	 else
	    ret = ret .. push("$1", true)
	 end
	 
      elseif instr == "string" then
	 ret = ret .. st(value)
	 
      elseif instr == "add" or instr == "sub" or instr == "sal" or instr == "sar"
      or instr == "sll" or instr == "slr" then
	 ret = ret .. op2(instr)
	 
      elseif instr == "mul" then
	 ret = ret .. mul()
	 
      elseif instr == "not" then
	 ret = ret .. nt()
	 
      elseif instr == "len" then
	 ret = ret .. len()
	 
      elseif instr == "neg" then
	 ret = ret .. neg()
	 
      elseif instr == "neq" then
	 ret = ret .. eq() ..
	    "\txor\t$8, " .. get(0) .. "\n"
	 
      elseif instr == "eq" then
	 ret = ret .. eq()

      elseif instr == "func" then
	 ret = ret .. push(false) ..
	    "\tlea\tfunction" .. value .. "(%rip), " .. get(0) .. "\n" ..
	    "\tlea\t7(, " .. get(0) .. ", 8), " .. get(0) .. "\n"

      elseif instr == "def" then
	 funcs = true
	 ret = ret .. "function" .. value .. ":\n"

      elseif instr == "gen" then
	 gen(tonumber(value))
	 ret = ret .. "\tcall\texpand\n" ..
	    "\tmov\t$" .. value .. ", %r9\n" ..
	    "\tcall\tdistribute\n"

      elseif instr == "arg" then
	 if value == "true" then
	    push(false)
	 end

      elseif instr == "args" then
	 args = tonumber(value)

      elseif instr == "call" then
	 ret = ret .. prepandret(args)
	 if modif then
	    integrate()
	 end

      elseif instr == "return" then
	 if type(get(0)) == "number" then
	    rpop()
	 end
	 pop()
	 pop()
	 rpop()
	 
	 --[[for i = 1, target do
	    printstacks()
	    push(false)
	    end]]
	 if target ~= 0 then
	    target = tostring(8 * (target - 9))
	 else
	    target = ""
	 end
	 push(false)
	 ret = ret ..
	    "\tadd\t$" .. target .. ", %rsp\n" ..
	    "\tpop\t%rax\n" ..
	    "\tret\n"
	 target = false

      elseif instr == "fend" then
	 ret = ret .. "\tmov\t$17, %rax\n"..
	    "\tret\n"
	 
      elseif instr == "index" then
	 ret = ret .. index(modif)
	 
      elseif instr == "check" then
	 ret = ret .. check()
	 
      elseif instr == "then" then
	 if buf then
	    ret = ret .. "\tmov\t" .. buf .. ", %rax\n"
	    buf = "%rax"
	 end
	 ret = ret .. "\tcmp\t$1, " .. get(0) .. "\n" ..
	    "\tjz\telse" .. value .. "\n" ..
	    "\tcmp\t$17, " .. get(0) .. "\n" ..
	    "\tjz\telse" .. value .. "\n"
	 pop()
	 
      elseif instr == "else" then
	 ret = ret .. "\tjmp\tiend" .. value .. "\n" ..
	 "else" .. value .. ":\n"
	 elses[value] = false
	 
      elseif instr == "iend" then
	 if elses[value] == nil then
	    ret = ret .. "else" .. value .. ":\n"
	 end
	 ret = ret .. "iend" .. value .. ":\n"
	 
      elseif instr == "ref" then
	 ret = ret .. push(get(tonumber(value)))
	 
      elseif instr == "var" then
	 ret = ret .. var(value)
	 
      elseif instr == "push" then
	 sets = sets + 1
	 ret = ret .. realpush()
	 
      elseif instr == "sets" then
	 push("%rsp")
	 modif = false
	 sets = 0
	 target = tonumber(value)
	 
      elseif instr == "stack" then
	 for i = 1, target - sets do
	    ret = ret .. push("$17", true) .. realpush()
	 end
	 
	 
      elseif instr == "store" then
	 --[[local tmp = get(0)
	 if tmp:sub(#tmp, #tmp) == ")" then
	    ret = ret .. popin() ..
	       "\tlea\t" .. tmp .. ", %rax\n"
	    buf = "%rax"
	    end]]
	 ret = ret .. realpush()
	 
      elseif instr == "modif" then
	 push("%rsp")
	 modif = true
	 
      elseif instr == "place" then
	 if type(get(0)) == "number" then
	    rpop()
	 end
	 pop()
	 pop()
	 rpop()
	 ret = ret ..
	    "\tpop\t%rax\n" ..
	    "\tmov\t$" .. tostring(target) .. ", %rcx\n" ..
	    "\tcall\tplace\n"
	    
	 for i = 1, target do
	    pop()
	    rpop()
	 end
	 target = false
	 
      elseif instr == "create" then
	 ret = ret .. push(false) ..
	    "\tlea\t3(, %rbp, 8), " .. get(0) .. "\n" ..
	    "\tadd\t$16, %rbp\n" .. push(false) ..
	    "\tlea\t-8(%rbp), " .. get(0) .. "\n"
	 
      elseif instr == "item" then
	 ret = ret ..
	    "\tlea\t4(, %rbp, 8), %rax\n" ..
	    "\tmov\t%rax, (" .. get(1) .. ")\n" ..
	    "\tmovq\t$" .. tostring(8 * tonumber(value)) .. ", (%rbp)\n" ..
	    "\tmovq\t" .. get(0) .. ", 8(%rbp)\n" ..
	    "\tadd\t$24, %rbp\n" ..
	    "\tlea\t-8(%rbp), " .. get(1) .. "\n"
	 pop()
	 
      elseif instr == "done" then
	 ret = ret ..
	    "\tmovq\t$17, (" .. get(0) .. ")\n" ..
	    "\tmov\t" .. get(1) .. ", %rax\n" ..
	    "\tsar\t$3, %rax\n" ..
	    "\tmovq\t$" .. tostring(8 * tonumber(value)) .. ", (%rax)\n"
	 pop()

      elseif instr == "free" then
	 ret = ret .. free(tonumber(value))

      elseif instr == "exit" then
	 ret = ret .. outro
	 if funcs then
	    ret = ret ..
	       "\n# FUNCTIONS" ..
	       "\n################################################################################\n"
	 end
	 
      end
      printstacks()
      ---------------------------
      s, i = readline(text, i)
   end
   if need_data then
      ret = ret .. data
   end
   return ret
end

--- TEMP ---
function printv(text)
   for i = 1, #vstack do
      print(text .. ": " .. vstack[i])
   end
end

function printstacks()
   print("\tREAL\t|\tVIRTUAL\t|\tBUF")
   print("--------------------------------------------------")
   local num, max = ""
   if vsize > rsize then
      max = vsize
   else
      max = rsize
   end
   for i = 1, max do
      if rstack[i] ~= nil then
	 num = "\t" .. tostring(rstack[i]) .. "\t|\t"
      else
	 num = "\t\t|\t"
      end
      if vstack[i] ~= nil then
	 num = num .. tostring(vstack[i]) .. "\t|\t"
      else
	 num = num .. "\t|\t"
      end
      if buf then
	 num = num .. buf
      end
      print(num)
   end
   print()
end

--------------------------------------------------------------------------------

local file = io.open(comp_file .. ".lir", "r")
text = file:read("all")
file:close()
file = io.open(comp_file .. ".s", "w+")
file:write(translate(text))
file:close()

