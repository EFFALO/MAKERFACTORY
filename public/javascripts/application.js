$(function(){
  
  var dimJobsForAnonymous = function() {
    if(!makerfactory.loggedIn) {
      $(':enabled').attr('disabled', 'disabled');
      $('div.page').addClass('dimmed');
      var notice = $('<div>').addClass('flash_notice yellow');
      notice.html('Hello, you need to <a href="/register">register</a> or <a href="/login">log in</a> before you post a job.');
      $('div#flash').append(notice);
    }
    
  };
  
  if($('form.job_form').length) {
    dimJobsForAnonymous();    
  }

  
  // old map stuff
  var map = new GMap2($("#map").get(0));
  map.addMapType({type:G_AERIAL_MAP});
  map.setMapType(G_AERIAL_MAP);
  var portlandOR = new GLatLng(45.51498682492308, -122.6799488067627);
  map.setCenter(portlandOR, 18);
});