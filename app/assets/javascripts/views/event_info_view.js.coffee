class Mihimihi.Views.EventInfoView extends Backbone.View

  template: JST['event_info_template']

  events:
    'click .icon' : -> @select()

  select: ->
    @the_event.collection.select(@the_event)

  initialize: (args) ->
    @time = @attributes.time
    
    @the_event = @model
    @dropTime = 500

    $(window).scroll((e) =>
      @animate()
    )
    $(window).resize((e) =>
      @animate()
    )

    @render()

  animate: ->
    ycenter = $(window).scrollTop() + ($(window).height()/2)
    if @y < ycenter - 200 or @y > ycenter + 200
      @the_event.set('selected',false)
    else
      @the_event.set('selected',true)

  render: () ->
    @y = @time(@the_event.get('years_ago'))
    y = @y
    $(@el).append(@template({the_event: @the_event, y: y}))
    @$('.large').hide();
    @$('.content').append(@the_event.get('content'))
    
    @mapView = new Mihimihi.Views.EventMapView({
      el: @$(".js-map[data-id=#{@the_event.id}]")
      model: @the_event, 
      attributes: {
        dropTime: @dropTime,
        height: 125
        width: 250
      }
    })

    @bigMapView = new Mihimihi.Views.EventMapView({
      el: @$(".js-big-map[data-id=#{@the_event.id}]")
      model: @the_event, 
      attributes: {
        dropTime: @dropTime,
        height: 480
        width: 780
        scale: 150
      }
    })

    @$('.action').click( => 
      @bigMapView.animate()
    )

