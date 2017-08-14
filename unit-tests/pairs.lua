local a = {1,2,3,4,5}
a["test"] = 1
a["bravo"] = 2
a["alpha"] = 3
a["beta"] = 4
a["bravo"] = nil
a[2.42] = "wow"

local b, c
while true do
   b, c = next(a, b)
   if not b then
      break
   end
   print(b, c)
end
--1	1
--2	2
--3	3
--4	4
--5	5
--test	1
--alpha	3
--beta	4
--2.42	wow

