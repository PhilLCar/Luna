r = { "%rax", "%rbx", "%rcx", "%rdx", "%rbp", "%rsp", "%rsi", "%rdi",
      "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" }

u = { "%rbx", "%rbp", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" } --rbp??
c = { "%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9", "%xmm0", "%xmm1",
      "%xmm2", "%xmm3", "%xmm4", "%xmm5", "%xmm6", "%xmm7" }



--[[
   ORDRE D'APPEL
   %rdi, %rsi, %rdx, %rcx, %r8, %r9, %xmm0 - %xmm7
]]

