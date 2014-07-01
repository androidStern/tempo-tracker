_ = require 'lodash'

###
  BPM CONVERSION HELPERS
------------------------------------------------
bpm_to_mspb, bpm_to_msp16th, mspb_to_bpm, msp16th_to_bpm
###

bpm_to_mspb = (bpm)->
  60000 / bpm

bpm_to_msp16th = (bpm)->
  bpm_to_mspb(bpm) / 4

mspb_to_bpm = (ms)->
  60000 / ms

msp16th_to_bpm = (bpm)->
  mspb_to_bpm(bpm) / 4


###
  MATH HELPERS
------------------------------------------------
sum, average, seccondLength, round, mode
###

sum = (a,b)->
  a + b

average = (list)->
  list.reduce(sum, 0) / list.length

seccondLength = (item)->
  item[1].length

round = (i)->
  Math.round(i)

mode = (list)->
  _(list).groupBy(round).pairs().sortBy(seccondLength).last()


###
  TIME HELPERS
------------------------------------------------
node_hrtime_to_ms
###

node_hrtime_to_ms = (t)->
  ms = t[1] / 1000000000
  (t[0] + ms) * 1000

###
  EXPORTS
------------------------------------------------
bpm_to_mspb, bpm_to_msp16th, mspb_to_bpm, msp16th_to_bpm, sum, average, seccondLength, round, mode
###

module.exports =
  bpm_to_mspb: bpm_to_mspb
  bpm_to_msp16th: bpm_to_msp16th
  mspb_to_bpm: mspb_to_bpm
  msp16th_to_bpm: msp16th_to_bpm
  sum: sum
  average: average
  seccondLength: seccondLength
  round: round
  mode: mode
  node_hrtime_to_ms: node_hrtime_to_ms
