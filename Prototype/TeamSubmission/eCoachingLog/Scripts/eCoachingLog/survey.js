$(function () {
	var isSubmitted = false;
	$('body').one('submit', '#survey-form', function (e) {
		// Just in case to prevent multiple submits
		if (!isSubmitted) {
			isSubmitted = true;
			$('#btn-submit').prop('disabled', true);
			$('#survey-form').data('serialize', $('#survey-form').serialize());
			$(".please-wait").slideDown(500);
			return true;
		}
		else {
			// Already submitted, do not submit again.
			return false;
		}
	});
});