class Mihimihi.Views.BackgroundMapView extends Backbone.View

  initialize: (args) ->
    @timelineEvents = @model
    @t = 0
    @render()


  render: () ->
    width = 960
    height = 500

    window.projection = d3.geo.equirectangular().scale(150).rotate([-180,0]);

    window.path = d3.geo.path().projection(projection);

    graticule = d3.geo.graticule();

    window.svg = d3.select("body").append("svg")
      .attr("width", width)
      .attr("height", height);
    
    land = svg.insert("path", ".graticule")
      .datum(topojson.object(worldtopo, worldtopo.objects.land))
      .attr("class", "land")
      .attr("d", path);

    $('.land').on('click', (e) => @t = @t+10; @rerender(); console.log @t)

    @g = svg.append('g')
    features = [{"type":"LineString","coordinates":[[35, 6], [42.6190, 11.5857]]}]
    @arrows = @g.selectAll("path")
      .data(features)
      .enter().append("path")
      .attr("d", (x) => @percentpath(path(x), @t))
      .attr('style', 'fill: none; stroke: black;')
      .attr('marker-end', 'url(#arrow)')

  rerender: () ->
    console.log("rerender")
    @arrows.attr("d", (x) => @percentpath(path(x), @t))

  percentpath: (pd,p) ->
    npd = Raphael.getSubpath(pd,0, p)
    console.log pd,npd
    return npd