class Mihimihi.Views.MapView extends Backbone.View

  getFeatures: (lonlat) ->
    if lonlat.type == "LineString"
      return [lonlat]
    else if lonlat.type == "MultiLineString"
      return ({type: "LineString", coordinates: x} for x in lonlat.coordinates)
    else if lonlat.type == "Point"
      return [lonlat]
    else if lonlat.type == "MultiPoint"
      return ({type: "Point", coordinates: x} for x in lonlat.coordinates)

  addFeatures: (features, g) ->
    return g.selectAll("path")
      .data(features)
      .enter().append("path")
      .attr("d", (x) => @path(x))
      .attr("class", "arrow")
      .attr('marker-end', (x) -> 
        if x.type == "LineString" 
          return 'url(#arrow)'; 
        else 
          return "")
      .attr('marker-start', 'url(#dot)')

  animateTimerThing: (func, callback) ->
    percent = 0
    frames = 25
    time = 700
    #clearInterval(@interval)
    
    interval = setInterval(() =>
      percent += 1/frames
      func(percent);
      if percent > 1
        clearInterval(interval)
        if callback
          callback() 
    , time/frames)


  calcDist: (p1,p2) ->
    #Haversine formula
    dLatRad = Math.abs(p1[1] - p2[1]) * Math.PI/180;
    dLonRad = Math.abs(p1[0] - p2[0]) * Math.PI/180;
    # Calculate origin in Radians
    lat1Rad = p1[1] * Math.PI/180;
    lon1Rad = p1[0] * Math.PI/180;
    # Calculate new point in Radians
    lat2Rad = p2[1] * Math.PI/180;
    lon2Rad = p2[0] * Math.PI/180;

    # Earth's Radius
    eR = 6371;
    d1 = Math.sin(dLatRad/2) * Math.sin(dLatRad/2) +
       Math.sin(dLonRad/2) * Math.sin(dLonRad/2) * Math.cos(lat1Rad) * Math.cos(lat2Rad);
    d2 = 2 * Math.atan2(Math.sqrt(d1), Math.sqrt(1-d1));
    return(eR * d2);


  animateFeatures: (features,callback) ->
    @animateTimerThing( (percent) =>
      features.attr("d", 
        (x) => 
          pd = @path(x)
          return pd if percent > 1 or x.type == "Point"
          return Raphael.getSubpath(pd, 0, percent*Raphael.getTotalLength(pd))
      )
      .attr('style', 
        (x) => 
          if percent > 1 or x.type == "LineString"
            ""
          else
            "stroke-width: #{percent*20};")
    ,callback)


  clearFeatures: (features) ->
    console.log "CLEAR", features
    features.attr("d", ()->"M-100,-100L-100,-100")

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
