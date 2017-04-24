-- Register information
--------------------------------------------------------------------------------
-- Registers (16)
r = { "%rax", "%rbx", "%rcx", "%rdx", "%rbp", "%rsp", "%rsi", "%rdi",
      "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }

-- Reserved: %rax, %rsp, %rbp

-- Usable registers (6)
u_reg  = 1
u_size = 6
u_name = { "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }
u_cont = {  0,      0,      0,      0,      0,      0     }

-- Calling registers (14)
c = { "%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9", "%xmm0", "%xmm1",
      "%xmm2", "%xmm3", "%xmm4", "%xmm5", "%xmm6", "%xmm7" }

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
   "\tmov\t%rax, %rbp\n" 
   --"\tmov\t%rbp, _mem_base(%rip)\n" ..
   --"\tmov\t%rsp, _stack_base(%rip)\n"

outro =
   "\tmov\t$0, %rax\n" ..
   "\tret\n"

need_data = false
data =
   "\n\n################################################################################\n" ..
   ".data\n\n"

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
   return vstack[index]
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
      local r, ret = register()
      vsize = vsize + 1
      vstack[vsize] = r
      ret = "\tmov\t" .. buf .. ", " .. r .. "\n"
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
   u_reg = (u_reg + 1) % u_size
   return u_name[(u_reg - 1) % u_size]
end

function current()
   return u_name[u_reg - 1]
end

function future()
   return u_name[u_reg]
end

function release()
   u_reg = (u_reg - 1) % u_size
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
   return "\tpush\t" .. n .. "\n"
end

-- *** Operating functions ***
--------------------------------------------------------------------------------
function realpush()
   local ret = ""
   if buf then
      ret = "\tpush\t" .. buf .. "\n"
      rpush("%rax")
      vpush(rsize)
      buf = false
   else
      release()
      rpush(vtop())
      ret = "\tpush\t" .. vtop() .. "\n"
      vstack[vsize] = rsize
   end
   return ret
end

function push(value)
   local ret = ""
   if buf then
      if available() then
	 ret = "\tmov\t" .. buf .. ", " .. register() .. "\n"
      else
	 ret = replace()
	 ret = ret .. "\tmov\t" .. buf .. ", " .. register() .. "\n"
      end
      vpush(current())
   end
   if not value then
      vpush(register())
   end
   buf = value
   return ret
end

function pop()
   local top, ret = vtop(), ""
   if buf then
      buf = false
      return ""
   end
   if type(top) == "number" then
      if top == rsize then
	 ret = "\tadd\t$8, %rsp\n"
      end
   end
   vpop()
   release()
   return ret
end

function free(index)
   if index == 0 then return ""
   elseif index < 0 then
      for i = 1, -index do
	 rpush("%rax")
	 vpush(rsize)
      end
      return "\tsub\t$" .. tostring(8 * -index) .. ", %rsp\n"
   end
   if buf then
      buf = false
      index = index - 1
      if index == 0 then return "" end
   end
   for i = vsize - index + 1, vsize do
      for j = 1, u_size do
	 if u_name[j] == vstack[i] then
	    release()
	 end
      end
      vstack[i] = nil
   end
   vsize = vsize - index
   return restore()
end

function restore()
   local max, ret = 0, ""
   if (vsize + 1) % u_size ~= u_reg then
      print("Possible stack corruption")
   end
   for i = 1, vsize do
      if type(vstack[i]) == "number" then
	 if vstack[i] > max then
	    max = vstack[i]
	 end
      end
   end
   for i = max + 1, rsize do
      --[[for j = 1, u_size do
	 if u_name[j] == rstack[i] then
	    release()
	 end
      end]]
      rstack[i] = nil
   end
   if rsize - max ~= 0 then
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
   local val = vat(vsize - index)
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

function op2(op)
   local ret = ""
   if not buf then
      buf = get(0)
      ret = pop()
   end
   ret = ret .. "\t" .. op .. "\t" .. buf .. ", " .. vtop() .. "\n"
   buf = false
   return ret
end

function neg()
   local ret = ""
   if buf then
      ret = "\tmov\t" .. buf .. ", %rsi\n" ..
	 "\tneg\t%rsi\n"
      buf = "%rsi"
   else
      ret = "\tneg\t" .. vtop() .. "\n"
   end
   return ret
end

function eq()
   local ret = ""
   if not buf then
      local tmp = get(0)
      ret = pop()
      buf = tmp
   end
   ret = ret .. "\tmov\t" .. buf .. ", %rsi\n" .. 
      "\tmov\t" .. vtop() .. ", %rdi\n" ..
      "\tcall\tcompare\n" ..
      "\tmov\t%rsi, " .. vtop() .. "\n"
   buf = false
   return ret
end

function len()
   local ret = ""
   if buf then
      ret = flatten()
   end
   ret = ret .. "\tsar\t$3, " .. vtop() .. "\n" ..
      "\tmov\t(" .. vtop() .. "), " .. vtop() .. "\n"
   return ret
end

notcount = 0
function nt()
   notcount = notcount + 1
   local ret, addr = "", tostring(notcount)
   if buf then
      ret = flatten()
   end
   ret = ret .. "\tcmp\t$1, " .. vtop() .. "\n" ..
      "\tjz\tnot" .. addr .. "\n" ..
      "\tmov\t$1, " .. vtop() .. "\n" ..
      "\tjmp\tnt" .. addr .. "\n" ..
      "not" .. addr .. ":\tmov\t$9, " .. vtop() .. "\n" ..
      "nt" .. addr .. ":"
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
   local modif = 0
   local elses = {}
   while s do
      instr, value = separate(s)
      ---------------------------
      if instr == "int" then
	 value = 8 * tonumber(value)
	 ret = ret .. push("$" .. tostring(value))
      elseif instr == "bool" then
	 if value == true then
	    ret = ret .. push("$9")
	 else
	    ret = ret .. push("$1")
	 end
      elseif instr == "string" then
	 ret = ret .. st(value)
      elseif instr == "add" or instr == "sub" or instr == "sal" or instr == "sar"
      or instr == "sll" or instr == "slr" then
	 ret = ret .. op2(instr)
      elseif instr == "not" then
	 ret = ret .. nt()
      elseif instr == "len" then
	 ret = ret .. len()
      elseif instr == "neg" then
	 ret = ret .. neg()
      elseif instr == "neq" then
	 --ret = ret .. neq()
      elseif instr == "eq" then
	 ret = ret .. eq()
      elseif instr == "index" then
	 
      elseif instr == "then" then
	 if buf then
	    ret = ret .. "\tmov\t" .. buf .. ", %rsi\n"
	    buf = "%rsi"
	 end
	 ret = ret .. "\tcmp\t$1, " .. get(0) .. "\n" ..
	    "\tjz\telse" .. value .. "\n"
	 pop()
      elseif instr == "else" then
	 ret = ret .. "\tjmp\tiend" .. value .. "\n" ..
	 "else" .. value .. ":\n"
	 elses[value] = false
      elseif instr == "iend" then
	 if elses[value] then
	    ret = ret .. "else" .. value .. ":\n"
	 end
	 ret = ret .. "iend" .. value .. ":\n"
      elseif instr == "ref" then
	 ret = ret .. push(get(tonumber(value)))
      elseif instr == "var" then
	 -- TEMPORAIRE
	 if value == "_print" then
	    ret = ret .. "\tpush\t" .. get(0) .. "\n" ..
	       "\tcall\tprint_lua\n\tcall\tprint_ret\n"
	    vpush(register())
	 end
      elseif instr == "push" then
	 modif = modif + 1
	 ret = ret .. restore() .. realpush()
      elseif instr == "sets" then
	 target = tonumber(value) + realsize()
      elseif instr == "stack" then
	 for i = realsize() - target, -1 do
	    rpush("%rax")
	    vpush(rsize)
	    ret = ret .. "\tpush\t$17\n"
	 end
	 ret = ret .. free(realsize() - target)
      elseif instr == "store" then
	 if buf then
	    ret = ret .. 
	       "\tlea\t" .. buf .. ", %rsi\n" ..
	       "\tpush\t%rsi\n"
	    rpush(buf)
	    vpush(rsize)
	    buf = false
	 else
	    ret = ret .. 
	       "\tlea\t" .. vtop() .. ", %rsi\n" ..
	       "\tpush\t%rsi\n"
	    rpush(vtop())
	    release()
	    vstack[vsize] = rsize
	 end
      elseif instr == "modif" then
	 modif = 0
	 ret = ret .. push("%rsp") .. flatten()
	 target = tonumber(value)
      elseif instr == "place" then
	 target = target + modif - 1
	 ret = ret .. 
	    "\tmov\t" .. get(target) .. ", %rsp\n"
	 for j = 1, target do
	    ret = ret .. "\tmov\t" .. tostring(-8 * j) .. "(%rsp), %rdi\n" .. 
	       "\tmov\t" .. tostring(-8 * (target + j)) .. "(%rsp), %rsi\n" ..
	       "\tmov\t%rsi, (%rdi)\n"
	 end
	 free(target + 2)
	 modif = false
      elseif instr == "create" then
	 ret = ret .. push(false) ..
	    "\tlea\t3(, %rbp, 8), " .. get(0) .. "\n" ..
	    "\tadd\t$16, %rbp\n" .. push(false) ..
	    "\tlea\t-8(%rbp), " .. get(0) .. "\n"
      elseif instr == "item" then
	 ret = ret ..
	    "\tlea\t4(, %rbp, 8), %rsi\n" ..
	    "\tmov\t%rsi, (" .. get(1) .. ")\n" ..
	    "\tmov\t$" .. tostring(8 * tonumber(value)) .. ", (%rbp)\n" ..
	    "\tmov\t" .. get(0) .. ", 8(%rbp)\n" ..
	    "\tadd\t$24, %rbp\n" ..
	    "\tlea\t-8(%rbp), " .. get(1) .. "\n"
	 pop()
      elseif instr == "done" then
	 pop()
	 ret = ret ..
	    "\tmov\t" .. get(0) .. ", %rsi\n" ..
	    "\tsar\t$3, %rsi\n" ..
	    "\tmov\t$" .. tostring(8 * tonumber(value)) .. ", (%rsi)\n"
	 print(ret)
      elseif instr == "free" then
	 ret = ret .. free(tonumber(value))
      end
      print(ret)
      printstacks()
      ---------------------------
      s, i = readline(text, i)
   end
   if need_data then
      outro = outro .. data
   end
   return ret .. outro
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

