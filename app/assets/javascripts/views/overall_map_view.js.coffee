class Mihimihi.Views.OverallMapView extends Mihimihi.Views.MapView

  initialize: (args) ->
    @timelineEvents = @model
    @time = @attributes.time
    
    console.log("render overall map")
    window.mmm = @
    @render()
    @$('.play').on('click', () => @animate())

  animate : () ->
    @$('.play, .countdown, .title').addClass('playing')

    done = []
    (@clearFeatures(f.feature) for f in @allFeatures)
    timing = 0
    @$('.countdown').text("")
    @$('.title').text("Tēnā koutou, tēnā koutou, tēnā koutou katoa")
    ninterval = setInterval(() =>
      d = true
      for ef in @allFeatures
        e = ef.event
        f = ef.feature
        if not (f in done)
          done.push(f)
          @$('.countdown').text("#{e.get('years_ago').addCommas()} years ago")
          @$('.title').text("#{e.get('title')}")
          @animateFeatures(f)
          d = false
          break
      if d 
        clearInterval(ninterval)
        @$('.play, .countdown, .title').removeClass('playing')
    ,2000)


  render: () ->
    width = 944
    height = 427

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
      @allFeatures.push({event: e, feature: features})
      @clearFeatures(features)

