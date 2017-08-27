print(string.format("Il y a %d pommes dans ce %s.", 6, "panier"))
print("La réponse est à la vie, l'univers et tout est " .. tostring(tonumber(" 32.24\n") + 9.76))
print(unpack{1,2,3,4})
local file = io.popen("echo allo")
io.write(file:read("all"))
file:close()
file = io.open("luna", "r")
print(file:read("line"))
print(file:read(nil, nil, nil))
print(file:read("number", "line") + 3)
print(file:read(5))
file:close()
file = io.open("doc/normes.txt", "r")
local file2 = io.open("test.out", "w")
local i = 1
for v in file:lines() do
   file2:write(i, ":\t", v, "\n")
   i = i + 1
end
file2:close()
file:close()
i = 1
for v in io.lines("test.out") do
   print(i, v)
   i = i + 1
end

io.popen("rm test.out"):close()

--Il y a 6 pommes dans ce panier.
--La réponse est à la vie, l'univers et tout est 42
--1	2	3	4
--allo
--#! /usr/bin/env lua
--local	i	=
--4
--comp_
--1	1:	000	Integer/Address
--2	2:	001	Special value
--3	3:	010	String
--4	4:	011	Table
--5	5:	100	Object
--6	6:	101	Stack
--7	7:	110	Double
--8	8:	111	Function



