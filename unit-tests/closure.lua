function test(a)
   local function x (b)
      return a + b
   end
   a = a + 2
   return x
end

local x, y = test(3), test(8)
print(x(5))
print(y(8))
--10
--18

