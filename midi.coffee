###
  REQUIRES
------------------------------------------------
###

{Guess_msp16th} = require './regress'
{msp16th_to_bpm, average, mode, node_hrtime_to_ms} = require './helpers'

_ = require 'lodash'
midi = require 'midi'

###
  CONSTANTS
------------------------------------------------
###

num_bpms_to_use = 12

num_times_to_use = 13

min_bpm = 80

max_bpm = 160

sample_rate = 360

###
  SETUP
------------------------------------------------
###

input = new midi.input()

input.openPort(0)

console.log input.getPortName(0)

start_time = process.hrtime() # Global Start Time

guess_msp16th = Guess_msp16th(min_bpm, max_bpm)

###
  GLOBAL STORAGE
------------------------------------------------
###

times = [] # drum onset times

bpms = [] # bpm estimations


###
  MAIN HELPERS
------------------------------------------------
###

process_bpms = (bpms)->
  _bpms = _.last(bpms, num_bpms_to_use)
  mode_obj = mode(_bpms)
  _mode = mode_obj[0]
  modes = mode_obj[1]
  avg = average(modes)
  return [_mode, avg]

addTime = (base_time)->
  times.push(node_hrtime_to_ms(process.hrtime(base_time)))

do_calc = (onset_times)->
  data = _.last(onset_times, num_times_to_use)
  offset = _.first(data)
  new_data = data.map (el)-> el - offset
  msp16th_to_bpm guess_msp16th(new_data)["guess"]


log_results = (obj)->
  console.log "instant: #{obj.instant}    mode: #{obj.mode}    average: #{obj.avg}"

###
  MAIN
------------------------------------------------
###

main = ->
  _bpm = do_calc(times)
  bpms.push(_bpm)
  [_mode, _avg] = process_bpms(bpms)
  log_results {instant: _bpm, mode: _mode, avg: _avg}

input.on 'message', (dt, msg)->
  if msg[2] isnt 0  # dont use note-off messages
    addTime(start_time)

setInterval main, sample_rate
