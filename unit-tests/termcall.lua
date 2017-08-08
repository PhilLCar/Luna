function term(a, b, c, d, e, f, g, h, i)
   if a == -1 then
      return a
   else
      return term(b - 1, c + 1, d - 1, e - 1, f + 1, g - 1, h + 1, i - 1, a + 1)
   end
end

print(term(10, 11, 12, 13, 14, 15, 16, 17, 18, 19))
---1


