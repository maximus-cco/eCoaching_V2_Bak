$(function () {
	// TODO: move to layout.js so it can be shared?
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
				data: { logId: $(this).data("log-id"), isCoaching: true },

				success: function (data) {
					$('#modal-container .modal-content').html(data);
					$('#modal-container').modal();
				},
				complete: function () {
					$(".please-wait").slideUp(500);
				}
			});
		}
	});

	$('body').on('submit', '#survey-form', function (e) {
		// Just in case to prevent multiple submits
		$('#btn-submit').prop('disabled', true);
		$('#survey-form').data('serialize', $('#survey-form').serialize());
		$(".please-wait").slideDown(500);
		return true;
	});
});