local ffi = require 'ffi'
local senna = require 'senna.env'
local C = senna.C

local POS = {}
local mt = {__index=POS}

function POS.new()
   local self = {}
   self.hash = senna.Hash(senna.path, "hash/pos.lst")
   self.c = C.SENNA_POS_new(senna.path, "data/pos.dat")
   ffi.gc(self.c, C.SENNA_POS_free)
   setmetatable(self, mt)
   return self
end

function POS:forward(tokens)
   local pos_labels = C.SENNA_POS_forward(self.c,
                                          tokens.c.word_idx,
                                          tokens.c.caps_idx,
                                          tokens.c.suff_idx,
                                          tokens.c.n)

   local tags = {__raw=pos_labels}
   for i=0,tokens.c.n-1 do
      tags[i+1] = self.hash:key(pos_labels[i])
   end
   return tags
end

senna.POS = {}
setmetatable(senna.POS,
             {__call=
                 function(self, ...)
                    return POS.new(...)
                 end,
              __index=POS,
              __newindex=POS})

return POS
