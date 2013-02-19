class Mihimihi.Views.EventMapView extends Backbone.View

  template: JST['event_map_template']

  initialize: (args) ->
    @the_event = @model
    @dropTime = @attributes.dropTime
    return "" if @the_event.get('lonlat') == null

    success = false
    try
      json = JSON.parse(@the_event.get('lonlat'));
      success = true
    catch error
      console.log "ERROR", @the_event.get('title')

    return "" if not success

    @the_event.bind('change:selected', (model,selected) =>
      @animate() if selected
    ) 

    @render() 



  render: () ->
    width = 400
    height = 250

    lonlat = JSON.parse(@the_event.get('lonlat'))

    [x,y] = d3.geo.centroid(lonlat)
    ll_center = [-x,-y]

    #setup
    #scale to right size
    #move center to 0,0
    #rotate map to center on coordinates
    projection = d3.geo.equirectangular()
    .scale(250)
    .translate([width/2,height/2])
    .rotate(ll_center)

    @path = d3.geo.path().projection(projection);

    #bounds takes feature
    #rotate takes lonlat
    #translate takes pixels
    
    graticule = d3.geo.graticule();

    el = $(".js-map[data-id=#{@the_event.id}]")[0]
    svg = d3.select(el).append("svg")
      .attr("width", width)
      .attr("height", height);
    
    @addMarkers(svg)

    svg.append("path")
    .datum(graticule.outline)
    .attr("class", "background")
    .attr("d", @path);

    land = svg.insert("path", ".graticule")
      .datum(topojson.object(worldtopo, worldtopo.objects.land))
      .attr("class", "land")
      .attr("d", @path);

    g = svg.append('g')


    if lonlat.type == "LineString"
      @addArrows([lonlat],g)
    else if lonlat.type == "MultiLineString"
      lonlats = ({type: "LineString", coordinates: x} for x in lonlat.coordinates)
      @addArrows(lonlats,g)
    else if lonlat.type == "Point"
      @addPoints([lonlat],g)
    

  addPoints: (points, g) ->
    @points = g.selectAll("path")
      .data(points)
      .enter().append("path")
      .attr("d", (x) => @path(x))
      .attr("class", "arrow")
      .attr('marker-start', 'url(#dot)')

  addArrows: (lonlats, g) ->
    @arrows = g.selectAll("path")
      .data(lonlats)
      .enter().append("path")
      .attr("d", (x) => @path(x))
      .attr("class", "arrow")
      .attr('marker-end', 'url(#arrow)')
      .attr('marker-start', 'url(#dot)')

  animateTimerThing: (func) ->
    @percent = 0
    frames = 25
    time = 700
    clearInterval(@interval)
    setTimeout(() =>
        @interval = setInterval(() =>
          @percent += 1/frames
          if @percent > 1
            clearInterval(@interval)
          func();
        , time/frames)
      ,@dropTime)

  animate: () ->
    console.log "animate"

    if @arrows
      @animateTimerThing(() => @animatePath())
    else if @points
      @animateTimerThing(() => @animatePoints())
  
  animatePoints: () ->

    @points.attr('style',(x) => 
      if @percent > 1
        ""
      else
        "stroke-width: #{@percent*20};"
    )

  animatePath: () ->
    @arrows.attr("d", (x) => 
        pd = @path(x)
        return pd if @percent > 1
        totalLength = Raphael.getTotalLength(pd)
        npd = Raphael.getSubpath(pd, 0, @percent*totalLength)
        return npd
        )

  pathForMarker: (marker) ->
    if marker == "arrow"
      return "M 0.0,0.0 L 5.0,-5.0 L -12.5,0.0 L 5.0,5.0 L 0.0,0.0 z "
    if marker == "dot"
      return "M -2.5,-1.0 C -2.5,1.7600000 -4.7400000,4.0 -7.5,4.0 C -10.260000,4.0 -12.5,1.7600000 -12.5,-1.0 C -12.5,-3.7600000 -10.260000,-6.0 -7.5,-6.0 C -4.7400000,-6.0 -2.5,-3.7600000 -2.5,-1.0 z "

  transformForMarker: (marker) ->
    if marker == "arrow"
      return "scale(0.2) rotate(180) translate(6,0)"
    if marker == "dot"
      return "scale(0.2) translate(7.4, 1)"

  addMarkers: (svg) ->
    svg.append("svg:defs").selectAll("marker")
      .data(["arrow","dot"])
    .enter().append("svg:marker")
      .attr("id", String)
      .attr("refX", 0)
      .attr("refY", 0)
      .attr("orient", "auto")
      .attr("style","overflow:visible;")
    .append("svg:path")
      .attr("id","path3774")
      .attr("d", (m) => @pathForMarker(m))
      .attr("style","fill-rule:evenodd;stroke-width:1.0pt;")
      .attr("transform",(m) => @transformForMarker(m))
