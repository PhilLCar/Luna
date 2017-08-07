function test(...)
   local x = { ... }
   return x
end

print(test(1, 2, 3)[2])
--2

