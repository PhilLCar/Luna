local test = {"ABonjour!A"}
function prob(a)
   local c = type(a)
   if c == "string" then
      return a:sub(2, -2)
   elseif c == "number" then
      return tostring(number)
   elseif c == "table" then
      return a[1]
   else
      return "Bienvenue"
   end
end
io.write(test[1]:sub(2, #test[1] - 1))
print()
io.write(prob():sub(5, -1))
print()
io.write(prob"aPommeD":sub(2, 3))
print()
--Bonjour!
--venue
--om

