###
  REQUIRES
------------------------------------------------
###

{ms_per_16th} = require './regress'
{msp16th_to_bpm, average, mode} = require './helpers'


_ = require 'lodash'
midi = require 'midi'

###
  CONSTANTS
------------------------------------------------
###

num_bpms_to_use = 10

num_times_to_use = 10


###
  SETUP
------------------------------------------------
###

input = new midi.input()

input.openPort(0)
console.log input.getPortName(0)

time = process.hrtime() # Global Start Time

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

process_bpms = ->
  _bpms = _.last(bpms, num_bpms_to_use)
  mode_obj = mode(_bpms)
  _mode = mode_obj[0]
  modes = mode_obj[1]
  avg = average(modes)
  return [_mode, avg]

addTime = ->
  t = process.hrtime(time)
  ms = t[1] / 1000000000
  _time = (t[0] + ms) * 1000
  times.push(_time)


do_calc = ->
  data = _.last(times, num_times_to_use)
  offset = _.first(data)
  new_data = data.map (el)-> el - offset
  res = msp16th_to_bpm ms_per_16th(new_data)["guess"]
  return res


log_results = (obj)->
  console.log "instant: #{obj.instant}    mode: #{obj.mode}    average: #{obj.avg}"

###
  MAIN
------------------------------------------------
###

input.on 'message', (dt, msg)->
  if msg[2] isnt 0  # dont use note-off messages
    addTime()
    _bpm = do_calc()
    bpms.push(_bpm)
    [_mode, _avg] = process_bpms()
    log_results {instant: _bpm, mode: _mode, avg: _avg}
