###
  REQUIRES
------------------------------------------------
###

Cost = require('./cost_fn').cost_fn
_ = require 'lodash'
{bpm_to_msp16th} = require './helpers'

###
  CONSTANTS
------------------------------------------------
###

min_bpm = 85
max_bpm = 160

###
  MAIN
------------------------------------------------
###

guesses = _.range(min_bpm, max_bpm, 1).map(bpm_to_msp16th)

ms_per_16th = (_data)->
  cost_fn = Cost(_data)
  cost = (guess)->
    _cost = cost_fn(guess)
    return {guess: guess, cost: _cost}
  _(guesses).map(cost).sortBy('cost').first()

###
  EXPORTS
------------------------------------------------
###

module.exports["ms_per_16th"] = ms_per_16th
