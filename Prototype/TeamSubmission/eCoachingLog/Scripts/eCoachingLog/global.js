window.history.forward();

$(function () {
	$(".please-wait").slideUp(500);

	// Init jquery user timeout plugin
	var userTimeoutPlugin = $(document).userTimeout({
		keepAliveUrl: keepSessionAliveUrl,
		logouturl: logoutUrl,
		session: 1500000, // Display modal dialog after user idles for 25 minutes (25*60*1,000 = 1500,000 milliseconds)
		timer: false,
		force: 240000, // Count down to 0, auto logout; set to 4 minutes (4*60*1,000 = 240,000 milliseconds)
		ui: 'bootstrap',
		modalBody: 'You\'re being timed out due to inactivity. Please choose to stay logged in or to logout. Otherwise, you will be logged out automatically.'
	});

	// Navbar sticks on top when scrolling down
	$('#topnavbar').affix({
		offset: {
			top: $('#banner').outerHeight(true)
		}
	});

    // stacked modals: https://jsfiddle.net/d16b5aoe/
	$(document).on('show.bs.modal', '.modal', function (event) {
	    var zIndex = 1040 + (10 * $('.modal:visible').length);
	    $(this).css('z-index', zIndex);
	    setTimeout(function () {
	        $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
	    }, 0);
	});

	//clear modal cache, so that new content can be loaded
	$('#modal-container').on('hidden.bs.modal', function () {
		$(this).removeData('bs.modal').find(".modal-content").empty();
	});

	// Handle global Ajax error
	$(document).ajaxError(function (event, jqxhr, settings, thrownError) {
		// Hide spinner
		$(".please-wait").slideUp(500);
		if (jqxhr.status === 403) {
			sessionExpired = true;
			window.location = sessionExpiredUrl;
		}
		else {
			errorOccured = true;
			window.location = errorUrl;
		}
	});

	$('body').on('shown.bs.collapse', '.collapse', function () {
	    $(this).parent().find(".glyphicon-plus").removeClass("glyphicon-plus").addClass("glyphicon-minus");
	    $(this).parent().find(".glyphicon-plus-sign").removeClass("glyphicon-plus-sign").addClass("glyphicon-minus-sign");
	});

	$('body').on('hidden.bs.collapse', '.collapse', function () {
	    $(this).parent().find(".glyphicon-minus").removeClass("glyphicon-minus").addClass("glyphicon-plus");
	    $(this).parent().find(".glyphicon-minus-sign").removeClass("glyphicon-minus-sign").addClass("glyphicon-plus-sign");
	});
});

