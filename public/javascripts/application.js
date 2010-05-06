$(function(){
  var map = new GMap2($("#map").get(0));
  map.addMapType({type:G_AERIAL_MAP});
  map.setMapType(G_AERIAL_MAP);
  var portlandOR = new GLatLng(45.51330163230602, -122.67764210700989);
  map.setCenter(portlandOR, 18);
});