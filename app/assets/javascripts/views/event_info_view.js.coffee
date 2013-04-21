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
    @the_event.bind('change:selected', (model,selected) =>
      if selected
        @expand()
      else
        @collapse()
    )
    @render()


  render: () ->
    y = @time(@the_event.get('years_ago'))
    $(@el).append(@template({the_event: @the_event, y: y}))
    @$('.large').hide();
    @$('.summary').append(@the_event.get('summary'))
    @$('.content').append(@the_event.get('content'))
    
    mapView = new Mihimihi.Views.EventMapView({
      el: @$(".js-map[data-id=#{@the_event.id}]")
      model: @the_event, 
      attributes: {
        dropTime: @dropTime,
        height: 125
        width: 250
      }
    })

    bigMapView = new Mihimihi.Views.EventMapView({
      el: @$(".js-big-map[data-id=#{@the_event.id}]")
      model: @the_event, 
      attributes: {
        dropTime: @dropTime,
        height: 250
        width: 500
      }
    })

  expand: () ->
    @$('.icon').attr('style', "background: url(#{@the_event.get('image').icon.url}) no-repeat;")
    @$('.large').slideDown(@dropTime);
    @$('.event').addClass('active')
    @$('.event').removeClass('not-active')

  collapse: () ->
    @$('.large').slideUp(@dropTime);
    @$('.event').removeClass('active')
    @$('.event').addClass('not-active')
    @$('.icon').attr('style', "background: url(#{@the_event.get('image').tiny.url}) no-repeat;")