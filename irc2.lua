-- Register information
--------------------------------------------------------------------------------
-- Registers (16)
r = { "%rax", "%rbx", "%rcx", "%rdx", "%rbp", "%rsp", "%rsi", "%rdi",
      "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }

-- Reserved:  %rax, %rbx, %rsp, %rbp
-- Conserved: %r12, %r13, %r14, %r15
--             MEM,  GBL,  CLO,  EMP

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
   "\tadd\t$16, %r12\n" ..
   "\tpush\t%rbp\n" ..
   "\tmov\t%rsp, %rbp\n"

outro =
   "\tpop\t%rsp\n"
   "\tmov\t$0, %rax\n" ..
   "\tret\n"

data = "\n# DATA" ..	    
   "\n################################################################################\n" ..
   ".data\n\n"

-- Internal stack structure
--------------------------------------------------------------------------------
buf = false

v_stack = {}
v_size  = 0

r_stack = { "%RET", "%rbp" }
r_size  = 2

-- Register handling functions
--------------------------------------------------------------------------------
function available()
   return not u_cont[(v_size + 1) % u_size]
end

function register()
   v_size = v_size + 1
   u_cont[v_size % u_size] = true
   v_stack[v_size] = u_name[v_size % u_size]
   return v_stack[v_size]
end

function current()
   return u_name[v_size % u_size]
end

function future()
   return u_name[(v_size + 1) % u_size]
end

function release()
   u_cont[v_size % u_size] = false
   v_stack[v_size] = nil
   v_size = v_size - 1
   return u_name[(v_size + 1) % u_size]
end

function replace()
   r_size = r_size + 1
   v_stack[v_size + 1 - u_size] = r_size
   r_stack[r_size] = register()
   return r_stack[r_size]
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

function pop()
   local tmp
   if buf then
      tmp = buf
      buf = nil
      return tmp
   else
      if type(v_stack[v_size]) == "number" then
	 return tostring(-8 * r_size) .. "(%rbp)"
	 

---------- FUNCTIONS ----------


---------- PARSING ----------
function readline(str, i)
   local s, ret
   while ret ~= "" do
      if i > #str then
	 return false, i
      end
      s = str:sub(i, i), ""
      while s ~= "\n" and i <= #str do
	 ret = ret .. s
	 i = i + 1
	 s = str:sub(i, i)
      end
      i = i + 1
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
   while s do
      instr, value = separate(s)
      --------------------
      
      --------------------
      s, i = readline(text, i)
   end
   ret = ret .. data
   return ret
end

local file = io.open(comp_file .. ".lir", "r")
text = file:read("all")
file:close()
file = io.open(comp_file .. ".s", "w+")
file:write(translate(text))
file:close()
