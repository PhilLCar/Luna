-- Mini Scheme!!
function cons(car, lst)
   return { car = car, cdr = lst }
end

function car(lst)
   return lst.car
end

function cdr(lst)
   return lst.cdr
end

function null(lst)
   return lst == nil
end

function list(...)
   local l, ac = {...}
   for i = #l, 1, -1 do
      ac = cons (l[i], ac)
   end
   return ac
end

function append(lst1, lst2)
   if not lst1 then
      return lst2
   end
   local l = lst1
   while not null(cdr(lst1)) do
      lst1 = cdr(lst1)
   end
   lst1.cdr = lst2
   return l
end

function iota(i, lst)
   if i == 0 then
      return lst
   else
      return iota(i - 1, cons(i, lst))
   end
end

function ok (row, dist, placed)
   if not placed then
      return true
   else
      return
	 (not (car(placed) == (row + dist))) and
	 (not (car(placed) == (row - dist))) and
	 ok(row, dist + 1, cdr(placed))
   end
end

function try(x, y, z)
   if null(x) then
      if null(y) then
	 return 1
      else
	 return 0
      end
   else
      return ((ok(car(x), 1, z) and
		  try(append(cdr(x), y), nil, cons(car(x), z))) or 0) +
	 try(cdr(x), cons(car(x), y), z)
   end
end

function nqueens(n)
   return try(iota(n, nil), nil, nil)
end

print(nqueens(2))
--0

