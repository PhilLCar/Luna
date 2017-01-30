#! /usr/bin/env lua
--  Pass   Fail   Unct     Progress                       234 / 352     Prct       Time
--[    0 |    0 |    0 ]  [##############################----------]  [  68% ]  [ 312.7s ]

function listdir(dir)
   local proc, files, i = io.popen("ls " .. dir), {}, 0
   for f in proc:lines() do
      if f:find(".lua") and not f:find(".pp.lua") then
	 i = i + 1
	 files[i] = f
      end
   end
   proc:close()
   return files
end

names = listdir("unit-tests")
total = 57
pass = 20
fail = 8
unkn = 12
time = os.clock()

function progress()
   local completed, prop = pass + fail + unkn
   io.write("  Pass   Fail   Unct     Progress                       " ..
	       string.format("%3d", completed) .. " / " ..
	       string.format("%3d", total) .. "     Prct       Time\n")
   io.write("[ \27[1;38;5;47m" .. string.format("%4d", pass) ..
	       "\27[0m | \27[1;38;5;203m" .. string.format("%4d", fail) ..
	       "\27[0m | \27[1;38;5;98m" .. string.format("%4d", unkn) ..
	       "\27[0m ]  [")
   prop = completed / total * 40
   for i = 1, 40 do
      if (i < prop) then
	 io.write("#")
      else
	 io.write("-")
      end
   end
   io.write("]  [ " .. string.format("%3.0f", prop / 40 * 100) .. "% ]  [ " ..
	       string.format("%5.1fs ]\n", os.clock() - time))
   io.write("\27[2A\27[90D\r")
end

progress()
progress()

io.write("\27[2B\r")
