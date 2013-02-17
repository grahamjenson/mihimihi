class Mihimihi.Routers.MihimihiRouter extends Backbone.Router
  routes:
    '': 'visualise'

  visualise: () ->
    timelineEvents = new Mihimihi.Collections.Events()
    timelineEvents.fetch().done(() ->
      mihi = new Mihimihi.Views.MihimihiView({el: '#container', model: timelineEvents})
    )