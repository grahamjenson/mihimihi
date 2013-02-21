class Mihimihi.Views.MihimihiView extends Backbone.View

  template: JST['mihimihi_template']

  initialize: ->
    @timelineEvents = @model
    
    $(window).scroll((e) =>
      @updateScroll()
    )
    $(window).resize((e) =>
      @updateScroll()
    )

    @render()

  render: () ->
    $(@el).html(@template())

    realWidth = 100
    realHeight = 10000

    @time = d3.scale.pow().exponent(.15209).range([0, realHeight]).domain([250000, 0])

    timeline = new Mihimihi.Views.TimelineView({el: '#js-timeline', model: @timelineEvents, attributes: {time: @time}})

    bgv = new Mihimihi.Views.BackgroundView()

    overallmap = new Mihimihi.Views.OverallMapView({el: '#js-overallmap', model: @timelineEvents})


    for e in @timelineEvents.models
      @$('#js-events-info').append("<div class='js-event-info' data-id='#{e.id}''></div>")
      eventinfo = new Mihimihi.Views.EventInfoView({el: @$(".js-event-info[data-id=#{e.id}]"), model: e, attributes: {time: @time}})

    @updateScroll()

  updateScroll: -> 
    #select events
    ycenter = $(window).scrollTop() + 100
    trange = [@time.invert(ycenter),@time.invert(ycenter-250)]

    be = _.sortBy(@timelineEvents.getEventsFromDate(trange), (e) -> e.get('years_ago'))[0]
    for e in @timelineEvents.models
      if e == be
        console.log(e.get('title'))
        e.set('selected',true)
      else
        e.set('selected',false)
    