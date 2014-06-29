find_nearest_multiple = (base_ms, test_point)->
  # base_ms = base_ms / 4
  Math.round(test_point / base_ms) * base_ms

delta_from_nearest_multiple = (base)-> (test)->
  Math.abs find_nearest_multiple(base, test) - test

cost_fn = (data)-> (base)->
  delta_fn = delta_from_nearest_multiple(base)
  reducer = (total, next)->
    delta_fn(next) + total
  data.reduce(reducer, 0) / data.length


module.exports["cost_fn"] = cost_fn
