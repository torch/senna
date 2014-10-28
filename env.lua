local ffi = require 'ffi'

local senna = {}

senna.C = ffi.load(package.searchpath('libsenna', package.cpath))

senna.path = package.searchpath('senna', package.path)
senna.path = senna.path:gsub('init.lua', '')

return senna
