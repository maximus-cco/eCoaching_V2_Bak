$(function () {
	const maxLength = 3000;
	// Ack - oppotunity
	$('body').on('keyup', '#textarea-employee-comments', function (e) {
	var remaining = maxLength - $(this).val().length;
	$('#employee-comments').text(remaining + ' remaining');
	});
	// Research - coachable
	$('body').on('keyup', '#DetailReasonCoachable', function (e) {
		var remaining = maxLength - $(this).val().length;
		$('#detail-reason-coachable').text(remaining + ' remaining');
	});
	// Research - not coachable
	$('body').on('keyup', '#DetailReasonNotCoachable', function (e) {
		var remaining = maxLength - $(this).val().length;
		$('#detail-reason-not-coachable').text(remaining + ' remaining');
	});
	// Cse - Yes
	$('body').on('keyup', '#DetailsCoached', function (e) {
		var remaining = maxLength - $(this).val().length;
		$('#cse-detail-remaining').text(remaining + ' remaining');
	});
	// Cse - No
	$('body').on('keyup', '#ReasonNotCse', function (e) {
		var remaining = maxLength - $(this).val().length;
		$('#non-cse-remaining').text(remaining + ' remaining');
	});
})