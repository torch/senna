local ffi = require 'ffi'
local senna = require 'senna.env'
local C = senna.C

local Hash = {}
local mt = {__index=Hash}

function Hash.new(path, filename, admiss_filename)
   assert(path, 'directory path mandatory')
   assert(filename, 'filename path mandatory')
   local self = {}
   if admiss_filename then
      self.c = C.SENNA_Hash_new_with_admissible_keys(path, filename, admiss_filename)
   else
      self.c = C.SENNA_Hash_new(path, filename)
   end
   ffi.gc(self.c, C.SENNA_Hash_free)
   setmetatable(self, mt)
   return self
end


function Hash:index(key)
   return tonumber(C.SENNA_Hash_index(self.c, key))
end

function Hash:key(idx)
   return ffi.string(C.SENNA_Hash_key(self.c, idx))
end

function Hash:size()
   return tonumber(C.SENNA_Hash_size(self.c))
end

function Hash:IOBES2IOB()
   C.SENNA_Hash_convert_IOBES_to_IOB(self.c)
end

function Hash:IOBES2BRK()
   C.SENNA_Hash_convert_IOBES_to_brackets(self.c)
end

senna.Hash = {}
setmetatable(senna.Hash,
             {__call=
                 function(self, ...)
                    return Hash.new(...)
                 end,
              __index=Hash,
              __newindex=Hash})

return Hash
