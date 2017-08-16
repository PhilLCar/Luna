local test =
   {"Bonjour!"; el1 = "allo "; el2 = "au revoir"; n = 100, 2, 3, [3] = 5}
for i, v in pairs(test) do
   print(i, v)
end

print(test[1])
print(test.el1 .. test.el2)
print(#test)
print(test[2] + test[3])

--1	Bonjour!
--2	2
--3	5
--el1	allo 
--el2	au revoir
--n	100
--Bonjour!
--allo au revoir
--3
--7

