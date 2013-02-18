class Mihimihi.Collections.Events extends Backbone.Collection
  
  url: "admin/events"

  model: Mihimihi.Models.Event

  getEventsFromDate: (trange) ->
    (m for m in @models when m.get('years_ago') > trange[0] and m.get('years_ago') < trange[1])