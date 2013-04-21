class Mihimihi.Views.ImageFloats extends Backbone.View

  initialize: (args) ->
    @time = @attributes.time
    console.log 'image'

    $(window).scroll((e) =>
      @render()
    )
    $(window).resize((e) =>
      @render()
    )

    @render()

  render: () ->
    _this = @
    @$('.backimg').each(() -> 
      _this.img_top($(this))
    )

  img_top: (img_el )->
    ycenter = $(window).scrollTop() + ($(window).height()/2)
    yo = img_el.attr('data-yo')
    img_el.css('top', @.time(yo))
    img_el.css('width', '100px')

