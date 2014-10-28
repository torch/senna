local ffi = require 'ffi'
local senna = require 'senna.env'
local C = senna.C

local Tokens = {}
local mt = {__index=Tokens}

function Tokens.new(c)
   local self = {c=c}
   setmetatable(self, mt)
   return self
end

function Tokens:words()
   local words = {}
   for i=0,self.c.n-1 do
      table.insert(words, ffi.string(self.c.words[i]))
   end
   return words
end

senna.Tokens = {}
setmetatable(senna.Tokens,
             {__index=Tokens,
              __newindex=Tokens})

return Tokens
