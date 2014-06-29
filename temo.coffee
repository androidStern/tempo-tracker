bpm_to_ms_per_beat = (bpm)->
  bpms = bpm / (60 * 1000)
  1 / bpms

bpm_to_ms_per_sixteenth = (bpm)->
  bpm_to_ms_per_beat(bpm)/ 4

make_sub_divisions_from_bpm = (bpm)->
  ms_per_16th = bpm_to_ms_per_sixteenth(bpm)
  [0..16].map (i)-> i * ms_per_16th


find_nearest_sub_division = (measure, ms)->
  for t,i in measure
    console.log "t: #{t}"
    console.log "i: #{i}"
    if t is ms
      console.log "ms: #{ms} matches t:#{t}"
      return i
    else if t > ms
      low = measure[i - 1]
      high = t
      lo_diff = ms - low
      hi_diff = high - ms
      if lo_diff < hi_diff
        console.log "ms: #{ms} was close to low: #{low}"
        return i - 1
      else
        console.log "ms: #{ms} was close to hi: #{high}"
        return i


calc_distance_from_nearest_sub = (measure, ms)->
  i = find_nearest_sub_division(measure, ms)
  Math.abs(measure[i] - ms)

calc_total_delta_for_times = (measure, times)->
  times.reduce (total, next)->
    total += calc_distance_from_nearest_sub(measure, next)


calc_deltas_with_bpm = (measure, bpm)->
  m = make_sub_divisions_from_bpm(120)
  console.log "SUBS: #{m}"
  d = calc_total_delta_for_times(m, measure)
  console.log "TOTAL DELTA: #{d} for guess bpm: #{bpm}"
  return d

inc_dec = (i)-> [i+1, i-1]

find_bpm_for_times = (times)->
  bpm_guess = 120
  better_guess = (g1, g2)->
    g_1 = Math.abs(g1-bpm_guess)
    g_2 = Math.abs(g2 - bpm_guess)
    g_f = Math.min(g_1, g_2)
  d = calc_deltas_with_bpm(times, bpm_guess)
  [bpm_up, bpm_down = inc_dec(bpm_guess)
  up_guess = calc_deltas_with_bpm(times, bpm_up)
  down_guess = calc_deltas_with_bpm(times, bpm_down)

times = [0, 150, 360, 500, 1000]
bpm = 120
guess = calc_deltas_with_bpm(times, 120)
console.log "Guess with times: #{times} at bpm: #{bpm} is #{guess} "
