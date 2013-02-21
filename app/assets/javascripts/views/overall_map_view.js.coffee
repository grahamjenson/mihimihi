class Mihimihi.Views.OverallMapView extends Mihimihi.Views.MapView

  initialize: (args) ->
    @timelineEvents = @model

    console.log("render overall map")
    window.mmm = @
    @render()
    @$('.play').on('click', () => @animate())

  animate : () ->
    @$('.play').addClass('playing')
    done = []
    (@clearFeatures(f) for f in @allFeatures)
    ninterval = setInterval(() =>
      d = true
      for f in @allFeatures
        if not (f in done)
          done.push(f)
          @animateFeatures(f)
          d = false
          break
      if d 
        clearInterval(ninterval)
        @$('.play').removeClass('playing')
    ,800)

  render: () ->
    width = 1000
    height = 500

    projection = d3.geo.equirectangular()
    .scale(150)
    .translate([width/2,height/2])
    .rotate([-180,0])
    @path = d3.geo.path().projection(projection);

    #bounds takes feature
    #rotate takes lonlat
    #translate takes pixels
    
    graticule = d3.geo.graticule();

    svg = d3.select(@el).append("svg")
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

    

    @allFeatures = []
    for e in _.sortBy(@timelineEvents.models, (e) -> - e.get("years_ago")) 
      g = svg.append('g')
      features = @addFeatures(@getFeatures(e.get('lonlat')),g)
      @allFeatures.push(features)
      @clearFeatures(features)

