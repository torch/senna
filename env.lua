local ffi = require 'ffi'

local senna = {}

senna.C = ffi.load(package.searchpath('libsenna', package.cpath))

senna.path = package.searchpath('senna', package.path)
senna.path = senna.path:gsub('init.lua', '')

if pcall(require, 'torch') then
   function senna.int2tbl(x, n)
      local tbl = torch.IntTensor(n)
      local tbl_p = tbl:data()
      for i=0,n-1 do
         tbl_p[i] = x[i]
      end
      return tbl
   end
else
   function senna.int2tbl(x, n)
      local tbl = {}
      for i=0,n-1 do
         tbl[i+1] = x[i]
      end
      return tbl
   end
end

return senna
