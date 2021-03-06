// Generated by CoffeeScript 1.4.0
(function() {
  var facebookMutualFriendObjectToD3Mapp;

  facebookMutualFriendObjectToD3Mapp = function(facebookMutualFriendObject) {
    var friend, friendLookupMap, friendsArray, i, link, links, mutualfriends, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
    friendLookupMap = {};
    friendsArray = [];
    links = [];
    _ref = facebookMutualFriendObject.data;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      friend = _ref[i];
      friendsArray.push({
        name: friend.name,
        id: friend.id,
        picture: friend.picture.data.url
      });
      friendLookupMap[friend.id] = i;
    }
    _ref1 = facebookMutualFriendObject.data;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      friend = _ref1[_j];
      if (friend.mutualfriends != null) {
        _ref2 = friend.mutualfriends.data;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          mutualfriends = _ref2[_k];
          if (friendLookupMap[friend.id] < friendLookupMap[mutualfriends.id]) {
            link = {
              source: friendLookupMap[friend.id],
              target: friendLookupMap[mutualfriends.id]
            };
            links.push(link);
          }
        }
      }
    }
    console.log("friendsArray", friendsArray);
    console.log("links", links);
    return {
      friends: friendsArray,
      links: links
    };
  };

  window.mateGraph = function(facebookMutualFriendObject) {
    var click, defs, e, force, friendData, friends, g, h, link, links, loadGraficNodes, loadGraphNode, mouseout, mouseover, node, r, svg, tick, w, z;
    e = document.documentElement;
    g = document.getElementsByTagName('body')[0];
    w = window.innerWidth || e.clientWidth || g.clientWidth;
    h = window.innerHeight || e.clientHeight || g.clientHeight;
    r = 12.5;
    z = d3.scale.category20c();
    svg = d3.select("#chart").append("svg:svg").attr("width", w).attr("height", h);
    defs = svg.append("svg:defs");
    defs.append("svg:clipPath").attr("id", "clipCircleSmall").append("svg:circle").attr("r", r).attr("cx", 0).attr("cy", 0);
    defs.append("svg:clipPath").attr("id", "clipCircleLarge").append("svg:circle").attr("r", 2 * r).attr("cx", 0).attr("cy", 0);
    svg.append("svg:g");
    friendData = facebookMutualFriendObjectToD3Mapp(facebookMutualFriendObject);
    console.log(friendData);
    tick = function() {
      link.attr("x1", function(d) {
        return d.source.x;
      }).attr("y1", function(d) {
        return d.source.y;
      }).attr("x2", function(d) {
        return d.target.x;
      }).attr("y2", function(d) {
        return d.target.y;
      });
      return node.attr("transform", function(d) {
        var x, y;
        x = Math.max(r, Math.min(w - r, d.x));
        y = Math.max(r, Math.min(h - r, d.y));
        return "translate(" + x + "," + y + ")";
      });
    };
    mouseover = function(d) {
      d3.select("r", 1.5 * d.r);
      return link.attr("class", function(o) {
        if (o.source === d || o.target === d) {
          return "link-highlight";
        } else {
          return "link";
        }
      });
    };
    mouseout = function(d) {
      d3.select(this).style("fill", "black");
      return link.style("class", "link");
    };
    click = function(d) {
      console.log(d);
      console.log(d3.select(this));
      d3.select(this).attr("class", "node highlight");
      return d3.select(this).append("svg:text").attr("class", "name").attr("dx", 12).attr("dy", ".35em").text(function(d) {
        return d.name;
      });
    };
    loadGraficNodes = function(links, friends) {
      console.log("loadGraficNodes: ");
      link.enter().append("svg:line").attr("class", "link");
      node.enter().append("svg:g").attr("class", "node").on("click", click).on("mouseover", mouseover).on("mouseout", mouseout).call(force.drag);
      node.append("svg:image").attr("xlink:href", function(d) {
        return d.picture;
      }).attr("x", -r).attr("y", -r).attr("width", 2 * r).attr("height", 2 * r);
      return node.append("svg:rect").attr("x", -r).attr("y", -r).attr("width", 2 * r).attr("height", 2 * r).attr("fill", "none").attr("class", function(d) {
        return "gender " + d.sex;
      });
    };
    friends = friendData.friends;
    links = friendData.links;
    node = svg.selectAll(".node").data(friends);
    link = svg.selectAll(".link").data(links);
    loadGraphNode = false;
    force = d3.layout.force().alpha(1).gravity(0.8).charge(-1000).linkDistance(30).size([w, h]).nodes(friends).links(links).on("tick", tick).start();
    return loadGraficNodes(links, friends);
  };

}).call(this);
