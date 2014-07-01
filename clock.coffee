{bpm_to_mspb} = require "./helpers"
midi = require('midi')
output = new midi.output()
output.openVirtualPort("AMS OUT")

bang = -> output.sendMessage [176,22,1]

Clock = (bpm)->
  interval = bpm_to_mspb(bpm)
  console.log "interval: #{interval}"
  console.log "running...."
  setInterval bang, interval


Clock(100)
