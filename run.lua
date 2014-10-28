local senna = require 'senna'

local tokenizer = senna.Tokenizer()

local pos = senna.POS()
local chk = senna.CHK('BRK')
local ner = senna.NER('BRK')
local srl = senna.SRL('BRK')

-- just concatenate the SRL tags for each tokenized word
local function srltagsat(srltags, words, idx)
   local txt = {}
   table.insert(txt, string.format('%20s', srltags.verb[idx] and words[idx] or '-'))
   for i=1,#srltags do
      table.insert(txt, string.format('%10s', srltags[i][idx]))
   end
   return table.concat(txt)
end

for line in io.lines() do
   local tokens = tokenizer:tokenize(line)
   local words = tokens:words()

   local postags = pos:forward(tokens)
   local chktags = chk:forward(tokens, postags)
   local nertags = ner:forward(tokens)
   local srltags = srl:forward(tokens, postags)

   for i=1,#postags do
      local txt = {}
      table.insert(txt, string.format('%20s', words[i]))
      if pos then
         table.insert(txt, string.format('%10s', postags[i]))
      end
      if chk then
         table.insert(txt, string.format('%10s', chktags[i]))
      end
      if ner then
         table.insert(txt, string.format('%10s', nertags[i]))
      end
      if srl then
         table.insert(txt, string.format('%10s', srltagsat(srltags, words, i)))
      end
      print(table.concat(txt))
   end

   print()
end
