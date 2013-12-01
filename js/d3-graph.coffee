
# spinnerOpts =
#   lines: 13 # The number of lines to draw
#   length: 7 # The length of each line
#   width: 4 # The line thickness
#   radius: 10 # The radius of the inner circle
#   corners: 1 # Corner roundness (0..1)
#   rotate: 0 # The rotation offset
#   color: "#000" # #rgb or #rrggbb
#   speed: 1 # Rounds per second
#   trail: 60 # Afterglow percentage
#   shadow: false # Whether to render a shadow
#   hwaccel: false # Whether to use hardware acceleration
#   className: "spinner" # The CSS class to assign to the spinner
#   zIndex: 2e9 # The z-index (defaults to 2000000000)
#   top: "auto" # Top position relative to parent in px
#   left: "auto" # Left position relative to parent in px

# spinnerTarget = document.getElementById("spinner")
# spinner = new Spinner(spinnerOpts).spin(spinnerTarget)

facebookMutualFriendObjectToD3Mapp = (facebookMutualFriendObject) ->
  friendLookupMap = {}
  friendsArray = []
  links = []



  for friend, i in facebookMutualFriendObject.data
    

    friendsArray.push
      name: friend.name
      id: friend.id
      picture: friend.picture.data.url
    friendLookupMap[friend.id] = i  
  

  for friend in facebookMutualFriendObject.data
    if friend.mutualfriends?
      for mutualfriends in friend.mutualfriends.data
        if(friendLookupMap[friend.id] < friendLookupMap[mutualfriends.id])  

          link =
            source: friendLookupMap[friend.id]
            target: friendLookupMap[mutualfriends.id]
          # console.log link  
          links.push link 

  console.log "friendsArray", friendsArray

  console.log "links", links

  {
    friends: friendsArray
    links: links
  }

#   friendLookupMap = {}
#   i = 0
#   for friend in friendsArray
#     console.log friend.uid
#     friendLookupMap[friend.uid] = i
#     i++
#     console.log friendLookupMap

#   for friend in friendsArray
#     for friendsFriendId in friend.friends
#       if(friendLookupMap[friend.uid] < friendLookupMap[friendsFriendId])  

#         link =
#           source: friendLookupMap[friend.uid]
#           target: friendLookupMap[friendsFriendId]
#         # console.log link  
#         links.push link 


# #############

#       friendsArray = fqlFriendList #res.data[0].fql_result_set
#       friendHashMap = {}
#       for friendObj in friendsArray
#         friendHashMap[friendObj.uid] = friendObj
      
      
#       async.map friendsArray, ((friend,cb)-> getMutualfriends(req,friend,cb)),(err, results)->
#         console.log err

#         console.log "results", results
        
#         for mutualfriends in results
#           for friendUid, friendsMutualFriends of mutualfriends
#             friendHashMap[friendUid].friends = friendsMutualFriends
        


#         links = []
#         friendLookupMap = {}
#         i = 0
#         for friend in friendsArray
#           console.log friend.uid
#           friendLookupMap[friend.uid] = i
#           i++
#           console.log friendLookupMap

#         for friend in friendsArray
#           for friendsFriendId in friend.friends
#             if(friendLookupMap[friend.uid] < friendLookupMap[friendsFriendId])  

#               link =
#                 source: friendLookupMap[friend.uid]
#                 target: friendLookupMap[friendsFriendId]
#               # console.log link  
#               links.push link 





window.mateGraph = (facebookMutualFriendObject)->
  
  
  e = document.documentElement
  g = document.getElementsByTagName('body')[0]
  w = window.innerWidth || e.clientWidth || g.clientWidth
  h = window.innerHeight|| e.clientHeight|| g.clientHeight;


  r = 12.5
  z = d3.scale.category20c()

  #.alpha(0.1)

  svg = d3.select("#chart")
    .append("svg:svg")
    .attr("width", w)
    .attr("height", h)

  defs = svg.append("svg:defs")
  defs.append("svg:clipPath")
    .attr("id", "clipCircleSmall")
    .append("svg:circle")
    .attr("r", r)
    .attr("cx", 0)
    .attr "cy", 0
  defs.append("svg:clipPath")
    .attr("id", "clipCircleLarge")
    .append("svg:circle")
    .attr("r", 2 * r)
    .attr("cx", 0)
    .attr "cy", 0
  svg.append "svg:g"

  # .attr("transform", "translate(" + w / 4 + "," + h / 3 + ")");

  # svg.append("svg:rect")
  #     .attr("width", w)
  #     .attr("height", h)
  #     .style("stroke", "#fff");


  # d3.json "friends.json?w=#{w}&h=#{h}", (friendData) ->
    # spinner.stop()
  friendData = facebookMutualFriendObjectToD3Mapp(facebookMutualFriendObject)
  console.log friendData
  # links = []
  # friendLookupMap = {}
  # i = 0
  # for friend in friendData
  #   console.log friend.uid
  #   friendLookupMap[friend.uid] = i
  #   i++
  # # console.log friendLookupMap

  # for friend in friendData
  #   for friendsFriendId in friend.friends
  #     if(friendLookupMap[friend.uid] < friendLookupMap[friendsFriendId])  
  #       link =
  #         source: friendLookupMap[friend.uid]
  #         target: friendLookupMap[friendsFriendId]
  #       links.push link 
  
      
  tick = ->
    # console.log w ,h 
    # console.log force.alpha()
    
    # if force.alpha() < 0.02 
    #   if not loadGraphNode
    #     loadGraphNode = true
    #     loadGraficNodes()
    #   # node.attr("cx", function(d){ return d.x = Math.max(r, Math.min(w - r, d.x)); })
      #     .attr("cy", function(d) { return d.y = Math.max(r, Math.min(h - r, d.y)); });
      
      # node.attr("x", function(d) { return d.x = Math.max(r, Math.min(w - r, d.x)); })
      #   .attr("y", function(d) { return d.y = Math.max(r, Math.min(h - r, d.y)); });
        
    link.attr("x1", (d) ->
      d.source.x
    ).attr("y1", (d) ->
      d.source.y
    ).attr("x2", (d) ->
      d.target.x
    ).attr "y2", (d) ->
      d.target.y

    node.attr "transform", (d) ->
      x = Math.max(r, Math.min(w - r, d.x))
      y = Math.max(r, Math.min(h - r, d.y))
      # console.log x ,y
      "translate(" + x + "," + y + ")"

  # Toggle children on click.
  mouseover = (d) ->
    d3.select "r", 1.5 * d.r
    


    link.attr "class", (o) ->
      (if o.source is d or o.target is d then "link-highlight" else "link")

  mouseout = (d) ->
    d3.select(this).style "fill", "black"
    link.style "class", "link"


  click = (d) ->
    console.log d
    console.log d3.select(this)
    d3.select(this).attr "class", "node highlight"
    d3.select(this)
      .append("svg:text")
      .attr("class", "name")
      .attr("dx", 12)
      .attr("dy", ".35em").text (d) ->
        d.name

  loadGraficNodes = (links, friends)->
    console.log "loadGraficNodes: "

    # link = svg.selectAll(".link")
    #   .data(links)
    link.enter()
      .append("svg:line")
      .attr("class", "link")
    
    node.enter()
      .append("svg:g")
      .attr("class", "node")
      .on("click", click)
      .on("mouseover", mouseover)
      .on("mouseout", mouseout)
      .call(force.drag)

    node.append("svg:image").attr("xlink:href", (d) ->
      d.picture
    )
    .attr("x", -r)
    .attr("y", -r)
    .attr("width", 2 * r)
    .attr "height", 2 * r
    node
    .append("svg:rect")
      .attr("x", -r)
      .attr("y", -r)
      .attr("width", 2 * r)
      .attr("height", 2 * r)
      .attr("fill", "none")

      .attr "class", (d)->
        "gender " + d.sex

      
    
    # node.forEach (d, i) ->
    #   d.x = d.y = w / 2 * i 


  # setTimeout(
  #   ()->
  #     console.log  force.nodes()
  #     # loadGraficNodes(links,friends)
  # , 10000)    
  
  friends = friendData.friends
  links = friendData.links

  node = svg.selectAll(".node")
    .data(friends)
      

  link = svg.selectAll(".link")
    .data(links)

  loadGraphNode = false
  
  


  force = d3.layout
    .force()
    .alpha(1)
    .gravity(0.8)
    .charge(-1000)
    .linkDistance(30)
    # .linkDistance((l,i )-> 
      
    #   # # friendScore = l.source.friends.length + l.target.friends.length

    #   # if friendScore > 50
    #   #   return 50
    #   # else
    #   #   friendScore
    # )
    .size([w , h])
    .nodes(friends)
    .links(links)
    .on("tick", tick)
    .start()



  loadGraficNodes(links, friends)
  


