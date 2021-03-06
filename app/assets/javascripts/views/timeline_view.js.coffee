class Mihimihi.Views.TimelineView extends Backbone.View

  template: JST['timeline_template']

  timetexttemplate: JST['timetext_template']

  initialize: (args) ->
    @time = @attributes.time
    @timelineEvents = @model
    @render()


  render: () ->
    major_ticks = [50,100,500,750,1000,2500,5000,7500,10000,20000,30000, 50000,75000,100000,150000,200000]
    timeline_ticks = (e.get('years_ago') for e in @timelineEvents.models when e.get('years_ago') > 0)
    major_ticks = _.union(timeline_ticks,major_ticks)
    height = @time(d3.min(major_ticks)) - @time(d3.max(major_ticks)) 

    $(@el).html(@template(height: height))



    
    for t in major_ticks
      y = @time(t)
      $("#js-vertical-timeline")
      .append(@timetexttemplate({t:t, y:y}))

    miny = @time(d3.max(major_ticks))
    maxy = @time(d3.min(major_ticks))
    $("#js-vertical-timeline")
      .append("<div class='actual-line' style='top: #{miny}px; height: #{maxy-miny}px'> </div>")