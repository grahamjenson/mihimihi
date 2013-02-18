class Mihimihi.Views.MihimihiView extends Backbone.View

  template: JST['mihimihi_template']

  initialize: ->
    @timelineEvents = @model
    
    $(window).scroll((e) =>
      @selectEvent()
    )
    $(window).resize((e) =>
      @selectEvent()
    )

    @render()

  render: () ->
    $(@el).html(@template())

    realWidth = 100
    realHeight = 10000

    @time = d3.scale.pow().exponent(.15209).range([0, realHeight]).domain([250000,0])

    timeline = new Mihimihi.Views.TimelineView({el: '#js-timeline', model: @timelineEvents, attributes: {time: @time}})

    #backgroundmap = new Mihimihi.Views.BackgroundMapView({el: '#js-background', model: @timelineEvents, attributes: {time: @time}})

    for e in @timelineEvents.models
      @$('#js-events-info').append("<div class='js-event-info' data-id='#{e.id}''></div>")
      eventinfo = new Mihimihi.Views.EventInfoView({el: @$(".js-event-info[data-id=#{e.id}]"), model: e, attributes: {time: @time}})

    @selectEvent()

  selectEvent: -> 
    ycenter = $(window).scrollTop() + $(window).height() / 2
    trange = [@time.invert(ycenter+150),@time.invert(ycenter-250)]
    events = @timelineEvents.getEventsFromDate(trange)
    console.log((e.get('title') for e in events))
    for e in @timelineEvents.models
      if e in events
        console.log(e.get('title'))
        e.set('selected',true)
      else
        e.set('selected',false)
    