MidiClock = require 'midi-clock'
midi = require('midi')

output = new midi.output()

output.openVirtualPort("AMS OUT")

clock = MidiClock()

clock.setTempo(120)

clock.start()

clock.on 'position', (p)->
  microPosition = p % 24
  if microPosition is 0
    console.log "Beat: #{p / 24}"
    output.sendMessage [176,22,1]
