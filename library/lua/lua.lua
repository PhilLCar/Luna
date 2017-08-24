function type(var)
   local x = _type(var)
   if x == 0 then
      -- integer
      return "number"
   elseif x == 1 then
      return "boolean"
   elseif x == 2 then
      return "string"
   elseif x == 3 then
      return "table"
   elseif x == 6 then
      -- double
      return "number"
   elseif x == 7 then
      return "function"
   end
   return "nil"
end

function tostring(var)
   local t = _type(var)
   if t == 1 then
      if var then return "true" end
      if var == false then return "false" end
      return "nil"
   elseif t == 2 then
      return var
   elseif t == 3 then
      return table
   elseif t == 6 then
      return _format_c("%.13g", var)
   end
end

function tonumber(var)
   local t = _type(var)
   if t == 2 then
      return _scan_c(var)
   elseif t == 0 or t == 6 then
      return var
   end
   return nil
end

function unpack(tab)
   return _unpack(tab)
end

function next(tab, index)
   return _next(tab, index)
end

function pairs(tab)
   return next, tab, nil
end

function ipairs(tab)
   local inext = function(tab, index)
      return _inext(tab, index)
   end
   return inext, tab, 0
end

function require(file_name)
end

function load(file_name)
end
