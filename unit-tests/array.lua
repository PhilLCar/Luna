local array = { 1+2, 2, {2,6},
		3, 4 }
array["test"] = array
local test = #array["test"] + #array["test"][3]
if test == 8 then
   array[3] = nil
end
#array
_print
--5

