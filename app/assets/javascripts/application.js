// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require_tree .
var options;
var chart;

jQuery.fn.center = function () {
    this.css("position","absolute");
    this.css("top", (($(window).height() - this.outerHeight()) / 2) + 
                                                $(window).scrollTop() + "px");
    this.css("left", (($(window).width() - this.outerWidth()) / 2) + 
                                                $(window).scrollLeft() + "px");
    return this;
}

$(document).ready(function(){
	/*$('#home-import-form')
		.bind("ajax:success", function(evt, status, xhr) {
			fadeOutContent('#content', function() {
				$('#wrapper').animate({width: '960px'}, 1000);
			});
		});*/

	$('form')
		.bind("ajax:error", function(event, xhr, status, error) {
			var message = $(xhr.responseText).fadeIn(500);

			$('#error-messages').html(message);
		});

/*	$("#usage-chart").fadeOut(500, function() {
		$(this).show();
		$.plot($(this), [{label: 'Energy Use', data:d, hoverable:true, points:{show:true}, lines:{show:true}},
						 {label: 'Average Use', data:a},
						 {label: 'CA Use', data:s},
						 {label: 'Cost', data:c, yaxis:2}], { xaxes: [{ mode: "time" }], yaxes: [{position: 'left'}, {position: 'right'}]});
//	});*/

	options = {
		chart: {
			renderTo: 'usage-chart'
		},
		title: {
			text: 'Your Energy Usage and Cost Over Time'
		},
		xAxis: [{
			type: 'datetime'
		}],
		yAxis: [{
			title: {
				text: 'Energy Use (Kwh)'
			},
			type: 'linear',
		}, {
			title: {
				text:'Cost ($ per Kwh)'
			},
			type: 'linear',
			opposite: true
		}],
		colors: [
			'#55AA55',
			'#CCCCFF',
			'#FF9999',
			'#88AADD',
		],
		plotOptions: {
            series: {
                marker: {
                    enabled: false,
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                }
            }
        },
		series: [{
			id: 'cost-series',
			data: c,
			name: 'Cost per Kwh',
			type: 'column',
			yAxis: 1
		}, {
			id: 'average-use-series',
			data: a,
			name: 'Average Use'
		}, {
			id: 'average-state-series',
			data: s,
			name: 'Average for CA'
		}, {
			id: 'energy-use-series',
			data: d,
			name: 'Energy Use'
		}]
	};

	chart = new Highcharts.Chart(options);
	chart.xAxis[0].setExtremes(start_date, end_date);

	$("#register-link").colorbox({
		href: "#register",
		inline: true,
		transition: 'fade'
	});

	$("#login-link").colorbox({
		href: "#login",
		inline: true,
		transition: 'fade'
	});
	/*$('.chart-link').each()
		.bind("ajax:loading", function() {
			$('#loading-indicator').center().fadeIn(500);
		});*/

	$.fn.serializeObject = function() {
	  var values = {}
	  $("form input, form select, form textarea").each( function(){
	    values[this.name] = $(this).val();
	  });
	  
	  return values;
	}

	$("form#ajax_signup").submit(function(e){
		alert('Happening');
	    e.preventDefault(); //This prevents the form from submitting normally
	    var user_info = $(this).serializeObject();
	    console.log("About to post to /users: " + JSON.stringify(user_info));
	    $.ajax({
	       type: "POST",
	       url: "http://localhost:3000/users",
	       data: user_info,
	       success: function(json){
	         console.log("The Devise Response: " + JSON.stringify(json));
	         //alert("The Devise Response: " + JSON.stringify(json));
	       },
	       dataType: "json"
	    });
	});
});

function fadeOutContent(element, callback) {
	var height = $(element).height();

	$(element).css('height', height);
	
	$(element).children().each(function() {
		$(this).fadeOut(500, callback);
	});
}