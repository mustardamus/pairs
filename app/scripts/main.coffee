jQuery ->
  if $('#isRemote').length
    Remote = require('./remote')
    new Remote
  else
    Desktop = require('./desktop')
    new Desktop

  Enc = require('./encryption')
  enc = new Enc