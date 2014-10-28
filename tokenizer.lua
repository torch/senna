local ffi = require 'ffi'
local senna = require 'senna.env'
local C = senna.C

local Tokenizer = {}
local mt = {__index=Tokenizer}

function Tokenizer.new(is_tokenized)
   is_tokenized = is_tokenized and 1 or 0
   local self = {}

   self.word_hash = senna.Hash(senna.path, "hash/words.lst")
   self.caps_hash = senna.Hash(senna.path, "hash/caps.lst")
   self.suff_hash = senna.Hash(senna.path, "hash/suffix.lst")
   self.gazt_hash = senna.Hash(senna.path, "hash/gazetteer.lst")

   self.gazl_hash = senna.Hash(senna.path, "hash/ner.loc.lst", "data/ner.loc.dat")
   self.gazm_hash = senna.Hash(senna.path, "hash/ner.msc.lst", "data/ner.msc.dat")
   self.gazo_hash = senna.Hash(senna.path, "hash/ner.org.lst", "data/ner.org.dat")
   self.gazp_hash = senna.Hash(senna.path, "hash/ner.per.lst", "data/ner.per.dat")

   self.c = C.SENNA_Tokenizer_new(self.word_hash.c,
                                  self.caps_hash.c,
                                  self.suff_hash.c,
                                  self.gazt_hash.c,
                                  self.gazl_hash.c,
                                  self.gazm_hash.c,
                                  self.gazo_hash.c,
                                  self.gazp_hash.c,
                                  is_tokenized)

   ffi.gc(self.c, C.SENNA_Tokenizer_free)

   setmetatable(self, mt)
   return self
end

function Tokenizer:tokenize(sentence)
   return senna.Tokens.new(C.SENNA_Tokenizer_tokenize(self.c, sentence))
end

senna.Tokenizer = {}
setmetatable(senna.Tokenizer,
             {__call=
                 function(self, ...)
                    return Tokenizer.new(...)
                 end,
              __index=Tokenizer,
              __newindex=Tokenizer})

return Tokenizer
