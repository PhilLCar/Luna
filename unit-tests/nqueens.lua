function append(lst1, lst2)
   if not lst1 then
      return lst2
   end
   local l = lst1
   while lst1.next ~= nil do
      lst1 = lst1.next
   end
   print(lst1.value)
   print(lst2.value)
   print(lst2)
   print(lst1.next)
   lst2.bob = "yo"
   a = "yo"
   lst1.next = "yo"
   print(lst1.next)
   print(a)
   print(lst2.bob)
   return l
end

function iota(i, lst)
   if i == 0 then
      return lst
   else
      return iota(i - 1, { next = lst, value = i })
   end
end
--[[
function ok (row, dist, placed)
   if not placed then
      return true
   else
      return
	 (not (placed.value == (row + dist))) and
	 (not (placed.value == (row - dist))) and
	 ok(row, dist + 1, placed.lnext)
   end
end

function try(x, y, z)
   if not x then
      if not y then
	 return 1
      else
	 return 0
      end
   else
      return ((ok(x.value, 1, z) and
		  try(append(x.lnext, y), nil, { lnext = z, value = x.value })) or 0) +
	 try(x.lnext, { lnext = y, value = x.value }, z)
   end
end

function nqueens(n)
   return try(iota(n, nil), nil, nil)
end
]]

l, b = iota(10, nil), iota(12, nil)

local l = append(l, b)
--[[
while l do
   print(l.value)
   l = l.lnext
end
]]
--print(append(iota(10, nil), iota(10,nil)))

--print(nqueens(2))
