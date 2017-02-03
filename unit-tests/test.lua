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
   print("Hello World!")
   local x,y =(2+ 3) - --[[INLINE!!]]((4 * -4) ^ 5)^9 > 2 and 1, "test"
      test = 1 + 3 + 4 + -- MULTILINE!
      5 + 6
      y = y:sub(1, 2)
   if x == 1 and y == "test" or y ~= 2 then
      print("yo")
   elseif x == 2 then
      print("wow")
   else
      print("test")
   end
   print(x)
   print(y)
end
--a
--
--Hello World!
--1
--te
