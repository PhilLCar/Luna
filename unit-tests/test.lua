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
      y = y:sub(1, 2)
   print(x)
   print(y)
end
