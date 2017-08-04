function test(a, b, c)
   return a, b, c
end

local w, x, y, z = 1, test(2, 3, 4), test(test(3, 4, 5))

print(w)
print(x)
print(y)
print(z)
--1
--2
--3
--4

