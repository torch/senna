local ffi = require 'ffi'
local senna = require 'senna.env'
local C = senna.C

local CHK = {}
local mt = {__index=CHK}

function CHK.new(hashtype)
   hashtype = hashtype or 'IOBES'
   local self = {}
   self.hash = senna.Hash(senna.path, "hash/chk.lst")
   if hashtype == 'IOBES' then
   elseif hashtype == 'IOB' then
      self.hash:IOBES2IOB()
   elseif hashtype == 'BRK' then
      self.hash:IOBES2BRK()
   else
      error('hashtype must be IOBES, IOB or BRK')
   end
   self.c = C.SENNA_CHK_new(senna.path, "data/chk.dat")
   ffi.gc(self.c, C.SENNA_CHK_free)
   setmetatable(self, mt)
   return self
end

function CHK:forward(tokens, pos_labels)
   assert(pos_labels, 'POS tags expected')
   local chk_labels = C.SENNA_CHK_forward(self.c,
                                          tokens.c.word_idx,
                                          tokens.c.caps_idx,
                                          pos_labels.__raw,
                                          tokens.c.n)

   local tags = {__raw=chk_labels}
   for i=0,tokens.c.n-1 do
      tags[i+1] = self.hash:key(chk_labels[i])
   end
   return tags
end

senna.CHK = {}
setmetatable(senna.CHK,
             {__call=
                 function(self, ...)
                    return CHK.new(...)
                 end,
              __index=CHK,
              __newindex=CHK})

return CHK
