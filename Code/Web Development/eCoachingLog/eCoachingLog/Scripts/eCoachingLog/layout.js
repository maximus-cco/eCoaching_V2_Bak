window.history.forward();

$(function () {
	$(".please-wait").slideUp(500);

	$('#modal-container').css('margin-top', '3%');
	$('.modal-content').css('width', '60%');

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

	// Prevent double click
	$('#mydashboard').on('click', function (e) {
		e.preventDefault();

		var href = $(this).attr('href');
		window.location.pathname = href;

		var $link = $(this);
		$link.prop('disabled', true);
		//$(".please-wait").slideDown(500);

		$.ajax({
			type: 'POST',
			// Call GetLogDetail method.
			url: myDashboardDefaultAjax,//'/MyDashboard/Default',
			dataType: 'html',
			success: function (data) {
				$('.body-content').html(data);
				$link.prop('disabled', false);
			}
		});
	});

	// http://www.codeproject.com/Tips/826002/Bootstrap-Modal-Dialog-Loading-Content-from-MVC-Pa
	// Initalize modal dialog
	// attach modal-container bootstrap attributes to links with .modal-link class.
	// when a link is clicked with these attributes, bootstrap will display the href content in a modal dialog.
	$('body').on('click', '.modal-link', function (e) {
		e.preventDefault();
		$(this).attr('data-target', '#modal-container');
		$(this).attr('data-toggle', 'modal');
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

});

