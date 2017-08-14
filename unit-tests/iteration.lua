local a = {1, 2, 3, 4, 5}
a.allo = "wow"
a.bye = "super"

for i, v in next, a, nil do
   print(i, v)
end
a[3] = nil 
for i, v in ipairs(a) do
   print(i, v)
end
--1	1
--2	2
--3	3
--4	4
--5	5
--allo	wow
--bye	super
--1	1
--2	2


