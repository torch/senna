local senna = require 'senna.env'
local C = senna.C

require 'senna.cdefs'
require 'senna.hash'
require 'senna.tokens'
require 'senna.tokenizer'
require 'senna.pos'
require 'senna.chk'
require 'senna.ner'
require 'senna.srl'

function senna.verbose(opt)
   opt = opt and 1 or 0
   C.SENNA_set_verbose_mode(opt)
end

return senna
