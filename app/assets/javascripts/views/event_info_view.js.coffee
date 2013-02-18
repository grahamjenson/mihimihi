class Mihimihi.Views.EventInfoView extends Backbone.View

  template: JST['event_info_template']

  initialize: (args) ->
    @time = @attributes.time
    @the_event = @model
    @the_event.bind('change:selected', (model,selected) =>
      console.log model, selected
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

    mapView = new Mihimihi.Views.EventMapView({model: @the_event })

  expand: () ->
    @$('.large').slideDown(500);

  collapse: () ->
    @$('.large').slideUp(500);