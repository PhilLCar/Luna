do
   local function x (a)
      if a == 1 then
	 return 1
      else
	 return a + x(a-1)
      end
   end
   print(x(10))
end
--55

