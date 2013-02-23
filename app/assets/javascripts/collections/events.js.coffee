class Mihimihi.Collections.Events extends Backbone.Collection
  
  url: "events"

  model: Mihimihi.Models.Event

  select: (be) ->
    for e in @models
      if e == be
        e.set('selected',true)
      else
        e.set('selected',false)

  initialize: (models) ->
    console.log "ASDASDSAD", models + ""
    (console.log(m) for m in @models)

  parse: (resp) ->
    ret = []
    for e in resp
      #test if lonlat can be parset
      success = false
      try
        e.lonlat = JSON.parse(e.lonlat);
        success = true
      catch error
        console.log "ERROR", e

      if not e.years_ago
        console.log "NO YEAR for",e
      else if (not e.lonlat) or (not success)
        console.log "ERROR", e
      else
        ret.push(e)

    return ret

  getEventsFromDate: (trange) ->
    (m for m in @models when m.get('years_ago') > trange[0] and m.get('years_ago') < trange[1])

  closestBelowDate: (d) ->
    bd = (m for m in @models when m.get('years_ago') < d)
    console.log()
    _.sortBy(bd , (e) -> Math.abs(d - e.get('years_ago')))[0]