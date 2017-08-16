local x, y, z = 1, 2, 3
print(1 == y and x[y]) -- false should prevent error
print(1 or x[y]) -- true should prevent error
-- The following line is the c equivalent of x ? y : z
print(x == x and y or z)
print(x == 2 and y or 3)
--false
--1
--2
--3

