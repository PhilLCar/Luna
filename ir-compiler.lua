r = { "%rax", "%rbx", "%rcx", "%rdx", "%rbp", "%rsp", "%rsi", "%rdi",
      "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }

-- Reserved: %rax, %rsp

-- Usable registers (8)
u_reg  = 1
u_size = 8
u_name = { "%rbx", "%rbp", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }
u_cont = {  0,      0,      0,      0,      0,      0,      0,      0     }

-- Calling registers (14)
c = { "%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9", "%xmm0", "%xmm1",
      "%xmm2", "%xmm3", "%xmm4", "%xmm5", "%xmm6", "%xmm7" }

intro =
   "\t.text\n" ..
   "\t.global\t_main\n" ..
   "\t.global\tmain\n" ..
   "_main:\n" ..
   "main:\n"

outro =
   "\tmov\t$0, %rax\n" ..
   "\tret\n"

function operation(instr)
   return instr == "add"
end

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

function release()
   u_reg = (u_reg - 1) % u_size
   u_cont[u_reg] = u_cont[u_reg] - 1
   return u_name[u_reg]
end
   

--[[ FLAG VALUES
   0 : int
   1 : stack
   2 : register
   3 : closure
]]
function push(value, flag)
   local s = ""
   if flag == 0 then --INT
      value = "$" .. value
      if available() then
	 s = "\tmov\t" .. value .. ", " .. register() .. "\n"
      else
	 local r = register()
	 s = "\tpush\t" .. r .. "\n" ..
	    "\tmov\t" .. value .. ", " .. r .. "\n"
      end
   elseif flag == 2 then
      
   end
   return s
end

function add(value)
   local s = ""
   if value then --INT
      value = "$" .. value
      s = "\tadd\t" .. value .. ", " .. current() .. "\n"
   else
      s = "\tadd\t" .. release() .. ", " .. current() .. "\n"
   end
   return s
end

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

function translate(text)
   local ret, buf = intro, false
   local s, i = readline(text, 1)
   local instr, value = separate(s)
   local nins, nval
   s, i = readline(text, i)
   if s then
      nins, nval = separate(s)
   else
      nins, nval = nil, nil
   end
   while instr do
      if instr == "int" then
	 if operation(nins) then
	    buf = value
	 else
	    ret = ret .. push(value, 0)
	 end
      elseif instr == "add" then
	 ret = ret .. add(buf)
	 buf = false
      else
      end
      
      instr, value = nins, nval
      s, i = readline(text, i)
      if s then
	 nins, nval = separate(s)
      else
	 nins, nval = nil, nil
      end
   end
   return ret .. outro
end

file = io.open("unit-tests/simple_add2.lir", "r")
test = file:read("all")
file:close()
print(translate(test))
--[[
file = io.open("unit-tests/simple_add2.lir", "w+")
file:write(scope(test, 0))
   file:close()]]

