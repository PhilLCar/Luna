local a = {1,2,3,4,5}
a["test"] = 1
a["bravo"] = 2
a["alpha"] = 3
a["beta"] = 4
a["bravo"] = nil

local b, c = next(a, 1)
print(c)
