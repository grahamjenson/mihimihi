class Mihimihi.Models.Event extends Backbone.Model

  initialize: () ->
    @set('selected',false)
    converter = new Markdown.Converter()
    @set('content', converter.makeHtml(@get('content')))