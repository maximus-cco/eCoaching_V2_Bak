$(function () {
	const maxLength = 3000;
	$('body').on('keyup', '#DetailsCoached', function (e) {
		var remaining = maxLength - $(this).val().length;
		$('#behavior-detail-remaining').text(remaining + ' remaining');
	});



})