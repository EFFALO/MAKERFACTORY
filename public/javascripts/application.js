$(function(){
  
  var dimJobsForAnonymous = function() {
    if(!makerFactory.loggedIn) {
      $(':enabled').attr('disabled', 'disabled');
      $('div.page').addClass('dimmed');
      var notice = $('<div>').addClass('flash_notice yellow');
      notice.html('Hello, you need to <a href="/register">register</a> or <a href="/login">log in</a> before you post a job.');
      $('div#flash').append(notice);
    }
    
  };
  
  var dimBidFormForAnonymous = function() {
    if(!makerFactory.loggedIn) {
      $(':enabled').attr('disabled', 'disabled');
      $('form.new_bid').addClass('dimmed');
      $('div.bid_instructions').html('<p>Hello, you need to <a href="/register">register</a> or <a href="/login">log in</a> before you can bid on this job.</p>');
      $('div#flash').append(notice);
    }
  };
  
  var bidSuccess = function(data, textStatus) {
    var success_text = 'YES YOU DONE SUBMITTED A BID';
    $('div.callout div.content h3').html('BID SUCCESSFUL');
    $('div.callout div.content div.bid_instructions').html(success_text);
    $('div.callout div.content form').empty();
    console.log('bid success');
  };
  
  var bindXhrBidPost = function() {
    $('form.new_bid').submit(function(event){
      event.preventDefault();
      var formEl = $(this);
      var data = formEl.serialize();
      // better validate
      $.post(formEl.attr('action'), data, bidSuccess);

      $(':enabled').attr('disabled', 'disabled');
      $('form.new_bid').addClass('dimmed');
      $('form.new_bid').prepend('<img src="/images/spinner.gif" class="spinner">');
      // if there is some kind of error
      // #hide/disable form
      // #disable button
      // #show spinner

    });
    
  };
  
  var bindAwardBidButtons = function() {
    var handleXHRsuccess = function(button) {
      button.hide(200, 'swing');
      var awarded = button.replaceWith('awarded!');
      awarded.show();
    };
    
    var buttons = elements.award_bid_links;
    buttons.each(function(){
      button = $(this);
      button.click(function(){
        button.unbind();
        $.post(button.attr('data-bid-award'), null, function(){
          handleXHRsuccess(button);
        });
      });
    });
  }
  
  var bindTRLinks = function() {
    $('tr').each(function(){
      var href = $(this).attr('data-href');
      if(href) $(this).click(function(){
        location.href = href;
      });
    });
  };
  
  // async load the gmaps scripts/API
  var loadGoogleMaps = function() {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.google.com/maps/api/js?sensor=false&callback=initializeGMaps";
    document.body.appendChild(script);
    
    // callback for when maps scripts load ... it has to be global???
    window.initializeGMaps = function() {
      // PDX, frankly
      var pdx = new google.maps.LatLng(45.51498682492308, -122.6799488067627);
      var myOptions = {
        zoom : 2,
        center : pdx, // obviously
        mapTypeId : google.maps.MapTypeId.ROADMAP,
        streetViewControl : false,
        mapTypeControl : false,
        scaleControl : false,
        navigationControl : true,
        navigationControlOptions : {
          style: google.maps.NavigationControlStyle.ZOOM_PAN
        }
      }
      var map = new google.maps.Map(elements.gmaps_canvas[0], myOptions);
      
      var drawAllJobs = function() {
        var currentMarker;
        var infoWindow = new google.maps.InfoWindow({
          maxWidth : 400
        });
        
        $.each(makerFactory.jobs, function(i, job){
          var drawMarker = function(geoResults) {
            var marker = new google.maps.Marker({
              map : map,
              clickable : true,
              position : geoResults[0].geometry.location
            });
            
            var img_tag = '';
            if (job.img_url) img_tag = '<img src="' + job.img_url + '" />';
            var content = 
              img_tag +
              '<a href="' + job.href + '">' +
                job.title +
              '</a>' +
              ' @ ' + job.location;
            
            var draw = function () {
              infoWindow.setContent(content);
              infoWindow.open(map, marker);
            }
            
            google.maps.event.addListener(marker, 'click', function(){
              if (!currentMarker) {
                currentMarker = marker;
                draw();
              } else if (currentMarker == marker) {
                infoWindow.close();
                currentMarker = null;
              } else {
                infoWindow.close();
                currentMarker = marker;
                draw();
              }

            });
          };
          
          new google.maps.Geocoder().geocode({
            address : job.location
          }, drawMarker);
          
        });
      };
      setTimeout(drawAllJobs, 0);
    };
    
  };
  
  var elements = {
    'award_bid_links' : $('tr.award_bid a'),
    'gmaps_canvas' : $('.gmaps_canvas')
  };
  
  if($('form.job_form').length) {
    dimJobsForAnonymous();
  }
  if($('form.new_bid').length) {
    dimBidFormForAnonymous();
    bindXhrBidPost();
  }
  if($('table').length) {
    bindTRLinks();
  }
  if(elements.award_bid_links.length) {
    bindAwardBidButtons();
  }
  if(elements.gmaps_canvas.length) {
    loadGoogleMaps();
  }
});