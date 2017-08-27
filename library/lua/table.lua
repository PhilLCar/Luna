table = {}

table.concat = function (tab, sep, i, j)
   local ret = ""
   if not i then i = 1 end
   if not j then j = #tab end
   if not sep then sep = "" end
   for k = i, j do
      local t, var = _type(tab[i])
      if t == 1 then
	 if tab[i] then var = "true"
	 elseif tab[i] == false then var = "false"
	 else var = "nil" end
      elseif t == 2 then
	 var = tab[i]
      elseif t == 3 then
	 var = _format_c("table: %p", tab[i])
      elseif t == 6 then
	 var = _format_c("%.13g", tab[i])
      elseif t == 6 then
	 var = _format_c("function: %p", tab[i])
      elseif t == 9 then
	 var = _format_c("file (%p)", tab[i])
      end
      ret = ret .. var
      if k ~= j then ret = ret .. sep end
   end
   return ret
end

table.foreach = function (tab, func)
   local t
   local iter = function (tab, index)
      _next(tab, index)
   end
   for i, v in iter, tab, nil do
      t = func(i, v)
      if t then break end
   end
end

table.foreachi = function (tab, func)
   local t
   local iter = function (tab, index)
      _inext(tab, index)
   end
   for i, v in iter, tab, 0 do
      t = func(i, v)
      if t then break end
   end
end

