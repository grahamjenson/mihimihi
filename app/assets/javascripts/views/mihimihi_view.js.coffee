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

    @time = d3.scale.pow().exponent(.15209).range([0, realHeight]).domain([240000,0])

    timeline = new Mihimihi.Views.TimelineView({el: '#js-timeline', model: @timelineEvents, attributes: {time: @time}})

    for e in @timelineEvents.models
      eventinfo = new Mihimihi.Views.EventInfoView({el: '#js-event-info', model: e, attributes: {time: @time}})

  selectEvent: -> 
    ycenter = $(window).scrollTop() + $(window).height() / 2
    trange = [@time.invert(ycenter-100),@time.invert(ycenter+100)]
    console.log(trange)
    