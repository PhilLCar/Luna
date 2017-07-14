--Ceci est un test
print("a")
--[[ 
   Ceci
   est
   autre
   un
   test
]]
io.write("\n")
--[==[
   Ceci est
   --[[ encore! ]]
   un autre test
]==]
do
   print('"Hello World!"')
   local x,y =(2+ 3) - --[[INLINE!!]]((4 * -4) ^ 5)^9 > 2 and 1, "test" .. "a"
      test = 1 + 3 + 4 + -- MULTILINE!
      5 + 6
   y = y  : sub(1, 3)
   t = {}
   t.a = "allo"
   t = t.a:sub(1, 2)
   function test2(prm, ...)
      x = x + 1
      return prm
   end
   if x == 1 and y == "test" or y ~= 2 then
      print([=[Waddup
 mo fo
]=])
      
   elseif x == 2 then
      print("wow")
   else
      print("test")
   end
   while x == 0 do
      x = 1
   end
   repeat
      x = 0
   until x == 0
   for i = 2, 10 do
      x = 2 * test2(x)
   end
   print(x)
   print(y)
end
--a
--
--Hello World!
--1
--te
