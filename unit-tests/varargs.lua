function test(...)
   local x = { ... }
   return x[2]
end

print(test(1, 2, 3))
--2

