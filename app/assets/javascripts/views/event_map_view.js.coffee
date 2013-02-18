class Mihimihi.Views.EventMapView extends Backbone.View

  template: JST['event_map_template']

  initialize: (args) ->
    @the_event = @model
    @t = 0
    if @the_event.get('lonlat') != null
      suc = false
      try
        json = JSON.parse(@the_event.get('lonlat'));
        suc = true
      catch error
        "ERROR"      
      @render() if suc



  render: () ->
    width = 1250
    height = 1250
    scale = 1

    lonlat = JSON.parse(@the_event.get('lonlat'))
    console.log(lonlat.coordinates[0])
    window.projection = d3.geo.equirectangular().scale(100).center([35,6]);

    @path = d3.geo.path().projection(projection);
    window.path = @path
    
    graticule = d3.geo.graticule();

    el = $(".js-map[data-id=#{@the_event.id}]")[0]
    svg = d3.select(el).append("svg")
      .attr("width", width)
      .attr("height", height);
    
    land = svg.insert("path", ".graticule")
      .datum(topojson.object(worldtopo, worldtopo.objects.land))
      .attr("class", "land")
      .attr("d", path);

    $('.land').on('click', (e) => @t = @t+10; @rerender(); console.log @t)

    @g = svg.append('g')
    lonlat = {"type":"LineString","coordinates":[[35, 6], [42.6190, 11.5857]]}
    @arrows = @g.selectAll("path")
      .data([lonlat])
      .enter().append("path")
      .attr("d", (x) => @percentpath(path(x), @t))
      .attr('style', 'fill: none; stroke: black;')
      .attr('marker-end', 'url(#arrow)')

  rerender: () ->
    console.log("rerender")
    @arrows.attr("d", (x) => @percentpath(@path(x), @t))

  percentpath: (pd,p) ->
    npd = Raphael.getSubpath(pd,0, p)
    console.log pd,npd
    return npd