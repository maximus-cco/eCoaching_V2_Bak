$(function () {
	$('body').on('submit', '#survey-form', function (e) {
		// Just in case to prevent multiple submits
		$('#btn-submit').prop('disabled', true);
		$('#survey-form').data('serialize', $('#survey-form').serialize());
		$(".please-wait").slideDown(500);
		return true;
	});
});