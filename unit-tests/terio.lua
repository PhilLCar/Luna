local billets = {12, 8, 9, 7, 14, 3, 1}
local min, max, total

for i = 1, #billets do
   if i == 1 then
      min = billets[i]
      max = billets[i]
      total = billets[i]
   else
      if min > billets[i] then
	 min = billets[i]
      end
      if max < billets[i] then
	 max = billets[i]
      end
      total = total + billets[i]
   end
end

print(min, max, total)

--1	14	54

