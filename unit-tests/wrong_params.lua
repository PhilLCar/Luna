function test(a, b, c, d, e, f, g, h, ...)
   x = { a, h, ... }
end

function test2(a, b)
   return a + b
end

function test3(a, b, c, d, e, f, g, h, i)
   return i
end

test(1)
print(x[2])
test(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
print(x[4])
print(test2(1,2,3,4,5))
print(test3(1,2))
--nil
--10
--3
--nil

