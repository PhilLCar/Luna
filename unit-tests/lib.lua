print(string.format("Il y a %.13g pommes dans ce %s.", 6, "panier"))
print("La réponse est à la vie, l'univers et tout est " .. tostring(tonumber(" 32.24\n") + 9.76))
print(unpack{1,2,3,4})
io.write(io.popen("echo allo"))
local file = io.open("luna", "r")
print(file:read("line"))
print(file:read(nil, nil, nil))
print(file:read("number", "line") + 3)
print(file:read(5))
file:close()
--print("test")
--print(file)

--Il y a 6 pommes dans ce panier.
--La réponse est à la vie, l'univers et tout est 42
--1	2	3	4
--allo

