$(function(){
  
  var dimJobsForAnonymous = function() {
    if(!makerFactory.loggedIn) {
      $(':enabled').attr('disabled', 'disabled');
      $('div.page').addClass('dimmed');
      var notice = $('<div>').addClass('flash_notice yellow');
      notice.html('Once you <a href="/register">register</a> or <a href="/login">log in</a> you can post a job using this form.');
      $('div#flash').append(notice);
    }
  };
  
  var dimBidFormForAnonymous = function() {
    if(!makerFactory.loggedIn) {
      $(':enabled').attr('disabled', 'disabled');
      $('form.place-a-bid').addClass('dimmed');
      $('div.bid_instructions').html('<p>Once you <a href="/register">register</a> or <a href="/login">log in</a> you can place a bid on this job.</p>');
      $('div#flash').append(notice);
    }
  };
    
  var bindXhrBidPost = function() {
    $('form.place-a-bid').submit(function(event){

      event.preventDefault();
      // clear previous failures
      $('.errorExplanation').remove();
      var formEl = $(this);
      var data = formEl.serialize();
      var placeToPutIt = $('form.place-a-bid').find('textarea')
      var spinner =  $('<div class="spinner"><img src="/images/spinner.gif"><br><span>working on it<span></div>');
      var coords = placeToPutIt.offset();

      var bidSuccess = function(data, textStatus) {
        var content = $(formEl).parent();

        if(data.errors) {
          bidFailure(data.errors)
          return
        }

        if('success' == textStatus) {
          content.empty();
          spinner.remove();
          content.append(data.partial);
          content.children().hide();
          content.children().fadeIn(300, 'swing');
          
          setTimeout(conditionalAddTrackerButtons,200);
        } else {
          throw 'non-200 result from POST'
        }
      };

      var bidFailure = function(errors) {
        var errors = $.map(errors, function (err, i) {
          var field = err[0].substring(0,1).toUpperCase() + err[0].substring(1);
          var humanReadable = field + ' ' + err[1] + '.';
          return {text : humanReadable};
        })
        var template = Handlebars.compile(makerFactory.templates.bidErrors);
        var data = { 'errors' : errors };
        var result = template(data);
        $(formEl).before(result)

        $(':disabled').attr('disabled', false);
        $('form.place-a-bid').removeClass('dimmed');
        spinner.remove();
      }

      var bidError = function(req,textStatus,err) {
        throw {
          'xhr' : req,
          'textStatus' : textStatus,
          'error' : err
        }
      }

      var conditionalAddTrackerButtons = function(counts) {
        // if jobs_count and bids_count are both zero, we know
        // that user previously was not shown the tracker link
        var shouldAddTrackerLink = !(makerFactory.jobs_count || makerFactory.bids_count)
        if(shouldAddTrackerLink) {
          var trackerLink = $('<li class="active"><a href="http://localhost:3000/tracker">TRACKER</a></li>');
          trackerLink.hide();
          $('div.nav li.profile').before($(trackerLink));
          trackerLink.fadeIn(500, 'swing');
        }
      };

      $.ajax({
        data     : data,
        dataType : 'json',
        error    : bidError,
        success  : bidSuccess,
        url      : formEl.attr('action'),
        type     : 'POST'
      })
      $(':enabled').attr('disabled', true);
      $('form.place-a-bid').addClass('dimmed');

      $('body').append(spinner);
      spinner.offset({
        left: coords.left + placeToPutIt.width()/2 - spinner.width()/2,
        top: coords.top + placeToPutIt.height()/2 - spinner.height()/2
      })

    });
  };
  
  var bindAwardBidButtons = function() {
    var handleXHRsuccess = function(button) {
      button.hide(200, 'swing');
      var awarded = button.replaceWith('<div class="awarded">Bid awarded!</div>');
      awarded.show();
    };
    
    var buttons = elements.award_bid_links;
    buttons.each(function(){
      button = $(this);
      button.click(function(e){
        e.preventDefault();
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
  var loadGoogleMaps = function(doneCallback) {
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
      
      var markers = [];
      var currentMarker;
      var infoWindow = new google.maps.InfoWindow({
        maxWidth : 400
      });
      var template = Handlebars.compile(makerFactory.templates.infoWindow);

      $.each(makerFactory.jobs, function(i, job){
        if(!(job.lat && job.lng)) return;

        var marker = new google.maps.Marker({
          map : map,
          clickable : true,
          position : new google.maps.LatLng(job.lat, job.lng, true)
        });
        markers.push({marker: marker, jobId: job.id});

        var content = template(job);
        var open = function () {
          infoWindow.setContent(content);
          infoWindow.open(map, marker);
        }
        var close = function () {
          infoWindow.close();
        };
        
        google.maps.event.addListener(marker, 'click', function(){
          if (!currentMarker) {
            currentMarker = marker;
            open();
          } else if (currentMarker == marker) {
            close();
            currentMarker = null;
          } else {
            close()
            currentMarker = marker;
            open();
          }
        });
          
      });

      // bind the non map clicks
      $('tr').each(function(){

        // this kills annoying double click text-selection
        // highlight
        var sel ;
        function clearSelection() {
          if(document.selection && document.selection.empty){
            document.selection.empty() ;
          } else if(window.getSelection) {
            sel=window.getSelection();
            if(sel && sel.removeAllRanges)
              sel.removeAllRanges() ;
          }
        }

        // HILARIOUS HAX
        setInterval(clearSelection, 25)
        // performance version
        //$(this).click(clearSelection);
        
        var jobId = $(this).attr('data-job-id');
        var marker = $(markers).filter(function(){
          return this.jobId == jobId;
        })[0];

        if (marker) {
          $(this).click(function(){
            google.maps.event.trigger(marker.marker, 'click');
          });
        } else {
          $(this).click(function(){
            infoWindow.close();
            currentMarker = null;
          });
        }
      });
    }; //initializeGMaps

  };

  var addClassOnCalloutHover = function() {
    $(elements.callout_link).each(function(){
      $(this).hover(function(){
        $(this).toggleClass('hover');
      });
    });
  }

  var bindGeocodeListener = function() {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.google.com/maps/api/js?sensor=false&callback=initializeGeocoder";
    document.body.appendChild(script);
    
    window.initializeGeocoder = function() {

      var formEl      = elements.geocoder_form[0]
      var locationEl  = elements.geocoder_location_field[0];
      var latEl       = elements.geocoder_lat_field[0];
      var lngEl       = elements.geocoder_lng_field[0];
      var geocoded    = false;

      // geocode it, then submit it whether or not we got any results ...
      $(formEl).submit(function(e) {
        if(!geocoded) {
          var locationVal = $(locationEl).val();
          e.preventDefault();
          new google.maps.Geocoder().geocode({
            address : locationVal
          }, didFinishGeocoding);
        } 
      });

      var didFinishGeocoding = function(geoResults) {
        if(geoResults.length) {
          var res = geoResults[0].geometry.location;
          $(latEl).val(res.lat());
          $(lngEl).val(res.lng());
        } else {
          $(latEl).val(null);
          $(lngEl).val(null);
        }
        geocoded = true;
        $(formEl).submit();
      }

    };
 
  };

  var bindImageDeletionControls = function () {
    elements.editable_images.each(function() {
      var imageContainer = $(this).find('.image_container');
      var deleteImg = $(this).find('.delete_button');
      var mainImg = $(this).find('.main_img');
      var fileFieldContainer = $(this).find('.file_field_container')
      var fileField = fileFieldContainer.find('input');
      var fileReplaceInstructions =  fileFieldContainer.find('.replace_instructions')

      // allows the controls to know if you've actually
      // left the main image, not simply entered a child 
      // element
      var isOutsideMainImg = function(e){
        var lOffset = mainImg.offset().left       // left
        var rOffset = lOffset + mainImg.width()   // right
        var tOffset = mainImg.offset().top        // top
        var bOffset = tOffset + mainImg.height(); // bottom

        if((e.pageX <= lOffset  || e.pageX >= rOffset) ||
          ( e.pageY <= tOffset  || e.pageY >= bOffset)) {
          return true;
        } else {
          return false;
        }
      }

      // ANIMATIONS

      var animateEnablingChooseFile = function () {
        deleteImg.remove();
        mainImg.fadeTo('fast',0.6,function(){
          fileFieldContainer.show();
          fileFieldContainer.css({
            left : (imageContainer.width() - fileFieldContainer.width()) / 2,
            top  : (imageContainer.height() - fileFieldContainer.height()) / 2
          })
          fileFieldContainer.fadeTo('fast',1.0)
          fileField.attr('disabled',false)
        })
      }

      var animateReplacingImage = function() {
        fileReplaceInstructions.text('');
        mainImg.fadeTo('fast', 0, function() {
          fileFieldContainer.css({
            left : (imageContainer.width() - fileFieldContainer.width()) / 2,
            top  : (imageContainer.height() - fileFieldContainer.height()) / 2
          })
          imageContainer.addClass('replaced'); 
        });
      }

      // BIND THINGS

      mainImg.hover(
        function(e) {
          deleteImg.show();
        },
        function(e) {
          if(isOutsideMainImg(e)){
            deleteImg.hide();
        }
      });
      deleteImg.hover(
        function(e) { },
        function(e) {
          if(isOutsideMainImg(e)) {
            deleteImg.hide();
          }
        }
      );
      deleteImg.click(function(){
        animateEnablingChooseFile();
      })
      fileField.change(function(){
        animateReplacingImage();
        fileField.unbind();
      })

    });

  };

  var elements = {
    'award_bid_links'         : $('.award_bid a').filter(function(){
      if($(this).attr('data-bid-award')) {
        return true;
      }
    }),
    'gmaps_canvas'            : $('.gmaps_canvas'),
    'callout_link'            : $('.callout.link .content'),
    'geocoder_lat_field'      : $('.geocoder_lat'),
    'geocoder_lng_field'      : $('.geocoder_lng'),
    'geocoder_location_field' : $('.geocoder_location'),
    'geocoder_form'           : $('.geocoder_form'),
    'editable_images'          : $('.editable_image')
    };
  
  // conditional hookups
  if($('form.job_form').length) {
    dimJobsForAnonymous();
  }
  if($('form.place-a-bid').length) {
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
    loadGoogleMaps()
  }
  if(elements.callout_link.length) {
    addClassOnCalloutHover();
  }
  if(elements.geocoder_form.length) {
    bindGeocodeListener();
  }
  if(elements.editable_images.length) {
    bindImageDeletionControls();
  }
});
