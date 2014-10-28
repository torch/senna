local ffi = require 'ffi'
local senna = require 'senna.env'
local C = senna.C

local SRL = {}
local mt = {__index=SRL}

function SRL.new(hashtype, verbtype)
   hashtype = hashtype or 'IOBES'
   verbtype = verbtype or 'VBS'
   local self = {verbtype=verbtype}
   self.hash = senna.Hash(senna.path, "hash/srl.lst")
   if hashtype == 'IOBES' then
   elseif hashtype == 'IOB' then
      self.hash:IOBES2IOB()
   elseif hashtype == 'BRK' then
      self.hash:IOBES2BRK()
   else
      error('hashtype must be IOBES, IOB or BRK')
   end
   if verbtype == 'VBS' then
      self.cvbs = C.SENNA_VBS_new(senna.path, "data/vbs.dat")
      ffi.gc(self.cvbs, C.SENNA_VBS_free)
   elseif verbtype ~= 'POS' and verbtype ~= 'USR' then
      error('verbtype must be VBS, POS or USR')
   end

   self.cpt0 = C.SENNA_PT0_new(senna.path, "data/pt0.dat")
   ffi.gc(self.cpt0, C.SENNA_PT0_free)
   self.csrl = C.SENNA_SRL_new(senna.path, "data/srl.dat")
   ffi.gc(self.csrl, C.SENNA_SRL_free)

   setmetatable(self, mt)
   return self
end

function SRL:forward(tokens, pos_labels, usr_vbs_labels)
   assert(pos_labels, 'POS tags expected')

   local vbs_labels
   if self.verbtype == 'VBS' then -- find verbs ourself
      vbs_labels = C.SENNA_VBS_forward(self.cvbs,
                                       tokens.c.word_idx,
                                       tokens.c.caps_idx,
                                       pos_labels.__raw,
                                       tokens.c.n)

      -- overwrite, who cares? you? you want to complain?
      for i=0,tokens.c.n-1 do
         vbs_labels[i] = vbs_labels[i] ~= 22 and 1 or 0
      end

   elseif self.verbtype == 'POS' then -- POS verbs
      -- it is GC'ed
      vbs_labels = ffi.new('int[?]', tokens.c.n)
      for i=0,tokens.c.n-1 do
         print('dude', pos_labels[i+1], pos_labels[i+1]:match('^V') and 1 or 0)
         vbs_labels[i] = pos_labels[i+1]:match('^V') and 1 or 0
      end
   else -- the user is maniac
      -- it is GC'ed
      assert(type(usr_vbs_labels) == 'table' and #usr_vbs_labels == tokens.c.n,
             'provide user verbs with a boolean table (size: number of tokens)')
      vbs_labels = ffi.new('int[?]', tokens.c.n)
      for i=0,tokens.c.n-1 do
         vbs_labels[i] = usr_vbs_labels[i+1] and 1 or 0
      end
   end

   local n_verbs = 0
   for i=0,tokens.c.n-1 do
      n_verbs = n_verbs + vbs_labels[i]
   end

   local pt0_labels = C.SENNA_PT0_forward(self.cpt0,
                                          tokens.c.word_idx,
                                          tokens.c.caps_idx,
                                          pos_labels.__raw,
                                          tokens.c.n)

   local srl_labels = C.SENNA_SRL_forward(self.csrl,
                                          tokens.c.word_idx,
                                          tokens.c.caps_idx,
                                          pt0_labels,
                                          vbs_labels,
                                          tokens.c.n)

   local tags = {__raw=srl_labels, verb={}}
   for j=0,tokens.c.n-1 do
      table.insert(tags.verb, vbs_labels[j] == 1)
   end
   for i=0,n_verbs-1 do
      local level_tags = {}
      for j=0,tokens.c.n-1 do
         table.insert(level_tags, self.hash:key(srl_labels[i][j]))
      end
      table.insert(tags, level_tags)
   end

   return tags
end

senna.SRL = {}
setmetatable(senna.SRL,
             {__call=
                 function(self, ...)
                    return SRL.new(...)
                 end,
              __index=SRL,
              __newindex=SRL})

return SRL
