class Mihimihi.Views.EventInfoView extends Backbone.View

  template: JST['event_info_template']

  initialize: (args) ->
    @time = @attributes.time
    @the_event = @model
    @render()


  render: () ->
    y = @time(@the_event.get('years_ago'))
    $(@el).append(@template({the_event: @the_event, y: y}))
