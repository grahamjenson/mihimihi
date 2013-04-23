class Mihimihi.Views.ImageFloats extends Backbone.View

  speed: 1.4

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
    $(@el).removeClass('hide')

  render: () ->
    _this = @
    @$('.backimg').each(() -> 
      _this.img_top($(this))
    )

  img_top: (img_el )->

    ycenter = $(window).scrollTop() + ($(window).height()/2)
    yo = @.time(img_el.attr('data-yo'))
    
    diffy = ycenter - yo
    difft = diffy * (1.0/@speed)
    ft = yo-difft

    img_el.css('top', ft)
    img_el.css('zindex', 10-@speed)

