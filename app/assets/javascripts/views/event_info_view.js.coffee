class Mihimihi.Views.EventInfoView extends Backbone.View

  template: JST['event_info_template']

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
    @$('.content').append(@the_event.get('content'))
    
    mapView = new Mihimihi.Views.EventMapView({model: @the_event, attributes: {dropTime: @dropTime}})

  expand: () ->
    @$('.large').slideDown(@dropTime);

  collapse: () ->
    @$('.large').slideUp(@dropTime);