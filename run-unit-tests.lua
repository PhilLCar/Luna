#! /usr/bin/env lua

function listlua()
   local proc, files, i = io.popen("ls ./unit-tests"), {}, 0
   for f in proc:lines() do
      if f:find(".lua") and not f:find(".pp.lua") and not f:find(".lua~") then
	 i = i + 1
	 files[i] = "unit-tests/" .. f
      end
   end
   proc:close()
   return files
end

function listexe()
   local proc, files, i = io.popen("ls ./unit-tests"), {}, 0
   for f in proc:lines() do
      if f:find(".exe") then
	 i = i + 1
	 files[i] = "unit-tests/" .. f
      end
   end
   proc:close()
   return files
end

function gettime()
   local file = io.popen("date +%s%N")
   local ret = tonumber(file:read("all"))
   file:close()
   return ret
end

function progress()
   local completed, prop = pass + fail + unkn
   io.write("  Pass   Fail   Unkn     Progress                       " ..
	       string.format("%3d", completed) .. " / " ..
	       string.format("%3d", total) .. "     Prct       Time\n")
   io.write("[ \27[1;38;5;47m" .. string.format("%4d", pass) ..
	       "\27[0m | \27[1;38;5;203m" .. string.format("%4d", fail) ..
	       "\27[0m | \27[1;38;5;98m" .. string.format("%4d", unkn) ..
	       "\27[0m ]  [")
   prop = completed / total * 40
   for i = 1, 40 do
      if (i <= prop) then
	 io.write("#")
      else
	 io.write("-")
      end
   end
   io.write("]  [ " .. string.format("%3.0f", prop / 40 * 100) .. "% ]  [ " ..
	       string.format("%5.1fs ]\n", (gettime() - time) / 1000000000))
   io.write("\27[2A\27[90D\r")
end

function getexpresult(filename)
   local file = io.open(filename, "r")
   local line = file:read("line")
   local ret = ""
   while line ~= nil do
      if line:sub(1, 2) == "--" then
	 ret = ret .. line:sub(3, #line)
	 line = file:read("line")
	 if line ~= nil then
	    ret = ret .. "\n"
	 end
	 
      elseif line ~= "" then
	 ret = ""
	 line = file:read("line")
      else
	 line = file:read("line")
      end
   end
   file:close()
   return ret
end

-- TESTING
----------------------------------------
names = listlua()
total = #names
pass = 0
fail = 0
unkn = 0
time = gettime()
failed = {}
fsize = 0

progress()

for i = 1, #names do
   -- Compile
   local name = names[i]
   os.execute("./luna " .. name .. " &> /dev/null")
   local execs = listexe()
   -- Execute
   local sname, present = name:sub(1, #name - 4) .. ".exe", false
   for i = 1, #execs do
      if execs[i] == sname then
	 present = true
      end
   end
   if present then
      local file = io.popen(sname)
      local result = file:read("all")
      file:close()
      local expected = getexpresult(name)
      if result == expected then
	 pass = pass + 1
      else
	 fail = fail + 1
	 fsize = fsize + 1
	 failed[fsize] = sname
      end
   else
      unkn = unkn + 1
      fsize = fsize + 1
      failed[fsize] = name
   end
   progress()
end

io.write("\27[2B\r")

print()
if pass == total then
   print("ALL UNIT TESTS PASSED")
else
   print(tostring(string.format("%.1f", (fail + unkn) / total * 100))
	    .. "% OF UNIT TESTS FAILED:")
   for i = 1, fsize do
      print("\t- " .. failed[i])
   end
end
