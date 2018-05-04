$(function () {
	// Display Review Modal
	$('body').on('click', '.modal-link', function (e) {
		//http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
		e.preventDefault();
		if (e.handled !== true) {
			e.handled = true;
			//console.log("!!!Get Detail!!!");
			$.ajax({
				type: 'POST',
				// Call GetLogDetail method.
				url: getLogDetailsUrl,
				dataType: 'html',
				data: { logId: $(this).data("log-id"), isCoaching: true },

				success: function (data) {
					$('.modal-content').html(data);
				}
			});
		}
	});
});