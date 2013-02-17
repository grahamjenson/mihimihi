class Mihimihi.Views.TimelineView extends Backbone.View

  template: JST['timeline_template']

  timetexttemplate: JST['timetext_template']

  initialize: (args) ->
    @time = @attributes.time
    @timelineEvents = @model
    @render()


  render: () ->
    $(@el).html(@template())

    ticks = [0, 1,2,3,5,10,50,100,200,500,750,1000,2500,5000,7500,10000,20000,30000, 50000,75000,100000,125000,150000,200000]

    for t in ticks
      y = @time(t)
      $("#js-vertical-timeline")
      .append(@timetexttemplate({t:t, y:y}))
