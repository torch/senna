local ffi = require 'ffi'
local senna = require 'senna.env'
local C = senna.C

local NER = {}
local mt = {__index=NER}

function NER.new(hashtype)
   hashtype = hashtype or 'IOBES'
   local self = {}
   self.hash = senna.Hash(senna.path, "hash/ner.lst")
   if hashtype == 'IOBES' then
   elseif hashtype == 'IOB' then
      self.hash:IOBES2IOB()
   elseif hashtype == 'BRK' then
      self.hash:IOBES2BRK()
   else
      error('hashtype must be IOBES, IOB or BRK')
   end
   self.c = C.SENNA_NER_new(senna.path, "data/ner.dat")
   ffi.gc(self.c, C.SENNA_NER_free)
   setmetatable(self, mt)
   return self
end

function NER:forward(tokens)
   local ner_labels = C.SENNA_NER_forward(self.c,
                                          tokens.c.word_idx,
                                          tokens.c.caps_idx,
                                          tokens.c.gazl_idx,
                                          tokens.c.gazm_idx,
                                          tokens.c.gazo_idx,
                                          tokens.c.gazp_idx,
                                          tokens.c.n)

   local tags = {__raw=ner_labels}
   for i=0,tokens.c.n-1 do
      tags[i+1] = self.hash:key(ner_labels[i])
   end
   return tags
end

senna.NER = {}
setmetatable(senna.NER,
             {__call=
                 function(self, ...)
                    return NER.new(...)
                 end,
              __index=NER,
              __newindex=NER})

return NER
