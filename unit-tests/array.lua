local array = { 1+2, {2,2},
		3, 4 }
array["test"] = array
local test = #array["test"]
_print
--5
