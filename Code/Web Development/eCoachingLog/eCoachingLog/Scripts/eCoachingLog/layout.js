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

	//clear modal cache, so that new content can be loaded
	$('#modal-container').on('hidden.bs.modal', function () {
		$(this).removeData('bs.modal').find(".modal-content").empty();
	});

	// Display Review Modal
	$('body').on('click', '.modal-link', function (e) {
		//http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
		e.preventDefault();
		if (e.handled !== true) {
			e.handled = true;
			//console.log("!!!Get Detail!!!");
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				// Call GetLogDetail method.
				url: getLogDetailsUrl,
				dataType: 'html',
				data: { logId: $(this).data("log-id"), isCoaching: $(this).data("is-coaching") },
				success: function (data) {
					$('#modal-container .modal-content').html(data);
					$('#modal-container').modal();
					$('#modal-container').modal('handleUpdate');
				},
				complete: function () {
					$(".please-wait").slideUp(500);
				}
			});
		}
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

});

