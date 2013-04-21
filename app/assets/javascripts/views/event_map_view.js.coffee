class Mihimihi.Views.EventMapView extends Mihimihi.Views.MapView

  template: JST['event_map_template']

  initialize: (args) ->
    @the_event = @model
    @dropTime = @attributes.dropTime
    @width = @attributes.width
    @height = @attributes.height

    @the_event.bind('change:selected', (model,selected) =>
      if selected
        @clearFeatures(@features)
        setTimeout(() => 
          @animateFeatures(@features)
        , @dropTime)
    ) 

    @render() 


  render: () ->
    width = @width
    height = @height

    lonlat = @the_event.get('lonlat')

    [x,y] = d3.geo.centroid(lonlat)
    ll_center = [-x,-y]

    bbox = d3.geo.bounds(lonlat)
    [x1,y1] = bbox[0]
    [x2,y2] = bbox[1]
    [xc,yc] = d3.geo.centroid(lonlat)
    distToCenterOfBbox = @calcDist([x2, y2],[xc,yc])
    
    minScale = 79
    maxScale = 300    
    scaleCalc = d3.scale.linear().range([maxScale,minScale]).domain([0,5000]).clamp(true)


    #setup
    #scale to right size
    #move center to 0,0
    #rotate map to center on coordinates
    s = scaleCalc(distToCenterOfBbox)
    projection = d3.geo.equirectangular()
    .scale(s)
    .translate([width/2,height/2])
    if s != 79
      #this scale shows the whole world, do not rotate
      projection.rotate(ll_center)
    else
      projection.rotate([-180,0])

    projection.clipExtent([[-50,-50],[width+50,height+50]])
    @path = d3.geo.path().projection(projection);

    #bounds takes feature
    #rotate takes lonlat
    #translate takes pixels
    
    graticule = d3.geo.graticule();

    svg = d3.select(@el).append("svg")
      .attr("width", width)
      .attr("height", height)

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

    lonlats = @getFeatures(lonlat)
    @features = @addFeatures(lonlats,g)
