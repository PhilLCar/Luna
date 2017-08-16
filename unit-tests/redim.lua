local test ={1,2,3, 4}
test[-3] = "allo"
test[10] = "bonjour"
for i = -8, 16 do
   print(i, test[i])
end
---8	nil
---7	nil
---6	nil
---5	nil
---4	nil
---3	allo
---2	nil
---1	nil
--0	nil
--1	1
--2	2
--3	3
--4	4
--5	nil
--6	nil
--7	nil
--8	nil
--9	nil
--10	bonjour
--11	nil
--12	nil
--13	nil
--14	nil
--15	nil
--16	nil

