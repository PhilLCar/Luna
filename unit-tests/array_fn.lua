function test()
   return 1, 2, 3
end

local x = { 4, 5, test()}

print(#x)
print(x[3])
--5
--1

