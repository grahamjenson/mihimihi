class Mihimihi.Collections.Events extends Backbone.Collection
  
  url: "events"

  model: Mihimihi.Models.Event

  getEventsFromDate: (trange) ->
    (m for m in @models when m.get('years_ago') > trange[0] and m.get('years_ago') < trange[1])

  closestBelowDate: (d) ->
    bd = (m for m in @models when m.get('years_ago') < d)
    console.log()
    _.sortBy(bd , (e) -> Math.abs(d - e.get('years_ago')))[0]