$(function(){
  var map = new GMap2($("#map").get(0));
  map.addMapType({type:G_AERIAL_MAP});
  map.setMapType(G_AERIAL_MAP);
  var portlandOR = new GLatLng(45.51498682492308, -122.6799488067627);
  map.setCenter(portlandOR, 18);
});