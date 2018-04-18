window.history.forward();

$(function () {
	$(".please-wait").slideUp(500);

	// Init jquery user timeout plugin
	$(document).userTimeout({
		keepAliveUrl: keepSessionAliveUrl,
		logouturl: logoutUrl,
		session: 1500000, // Display modal dialog after user idles for 25 minutes (25*60*1,000 = 1500,000 milliseconds)
		force: 290000, // Count down to 0, auto logout; set to 5 minutes minus 10 seconds (5*60*1,000 - 10,000 = 290,000 milliseconds)
		ui: 'bootstrap',
		modalBody: 'Your session is about to expire. Please click the button if you wish to stay connected. Otherwise, you will be logged out automatically.'
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
		//alert(href);
		//alert(getDefault);

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
				//alert(data);
				$('.body-content').html(data);
				//$(".please-wait").slideUp(500);
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
		$(".please-wait").slideDown(500);
		$(this).attr('data-target', '#modal-container');
		$(this).attr('data-toggle', 'modal');
		$(".please-wait").slideUp(500);
	});

	// Attach listener to .modal-close-btn's so that when the button is pressed the modal dialog disappears
	//$('body').on('click', '.modal-close-btn', function () {
	//    alert('close');
	//    $('#modal-container').modal('hide');
	//});

	//clear modal cache, so that new content can be loaded
	$('#modal-container').on('hidden.bs.modal', function () {
		$(this).removeData('bs.modal').find(".modal-content").empty();
	});

	$.ajaxSetup({
		// Global ajax error function
		error: function (xhr, status, errorMsg) {
			// Hide spinner
			$(".please-wait").slideUp(500);
			if (xhr.status === 403) {
				//alert('403');
				sessionExpired = true;
				window.location = sessionExpiredUrl;
			}
			else {
				window.location = errorUrl;
			}
		}
	});
});

