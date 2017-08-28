function add(v1, v2)
--[[ 
      Ceci est un exemple de fichier qui 
      sera "préprocessé", similaire au code
      du compilateur-ir
   ]]
   local function mem(v)
      if true and v then
	 v = "(" .. "%rbx" .. ")"
      end
   end
   return "\tmovq\t" .. v1 .. ", %rax\n" ..
      "\tmovq\t" .. v2 .. ", %rdx\n" .. -- v2 dans %rdx
      "\addq\t" .. "%rax" .. ", " .. "%rdx" .. "\n"
end
