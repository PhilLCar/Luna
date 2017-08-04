function test()
   return 1, 2, 3
end

function get2(array)
   return array[2]
end

local a = {8, test()}

print(#a + get2{1,3,5})
