$(function () {
	$('#radioBtn a').on('click', function () {
		var sel = $(this).data('title');
		var tog = $(this).data('toggle');
		$('#' + tog).prop('value', sel);

		$('a[data-toggle="' + tog + '"]').not('[data-title="' + sel + '"]').removeClass('active').addClass('notActive');
		$('a[data-toggle="' + tog + '"][data-title="' + sel + '"]').removeClass('notActive').addClass('active');

		$('#div-statistics').removeClass("show").addClass("hide");

		$('#byWhat').val(sel);
		switch (sel) {
			case 'H':
				$('#div-by-hour').removeClass("hide").addClass("show");
				$('#div-by-day').removeClass("show").addClass("hide");
				$('#div-by-week').removeClass("show").addClass("hide");
				$('#div-by-month').removeClass("show").addClass("hide");
				break;
			case 'D':
				$('#div-by-day').removeClass("hide").addClass("show");
				$('#div-by-hour').removeClass("show").addClass("hide");
				$('#div-by-week').removeClass("show").addClass("hide");
				$('#div-by-month').removeClass("show").addClass("hide");
				break;
			case 'W':
				$('#div-by-week').removeClass("hide").addClass("show");
				$('#div-by-hour').removeClass("show").addClass("hide");
				$('#div-by-day').removeClass("show").addClass("hide");
				$('#div-by-month').removeClass("show").addClass("hide");
				break;
			case 'M':
				$('#div-by-month').removeClass("hide").addClass("show");
				$('#div-by-hour').removeClass("show").addClass("hide");
				$('#div-by-day').removeClass("show").addClass("hide");
				$('#div-by-week').removeClass("show").addClass("hide");
				break;
		}
	});

	$('body').on('click', '#btn-go', function (e) {
		e.preventDefault();

		if (e.handled !== true) {
			e.handled = true;
			 
			if (!validate())
			{
				return false;
			}

			var start;
			var end;
			var byWhat = $('#byWhat').val();
			if (byWhat === 'H')
			{
				start = $('#daySelected').val();
			} else if (byWhat === 'D')
			{
				start = $('#startDate').val();
				end = $('#endDate').val();
			} else if (byWhat === 'W') {
				start = $('#startWeek').val();
				end = $('#endWeek').val();
			} else if (byWhat === 'M') {
				start = $('#startMonth').val();
				end = $('#endMonth').val();
			}

			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				url: getStatistics,
				data: {
					byWhat: byWhat,
					startDate: start,
					endDate: end
				},
				success: function (data) {
					$(".please-wait").slideUp(500);
					$('#div-statistics').removeClass("hide").addClass("show");
					$('#div-statistics').html(data);
				}
			});
		}
	});

	function validate()
	{
		var isValid = false;
		var byWhat = $('#byWhat').val();
		switch (byWhat) {
			case 'H':
				if (!$('#daySelected').val())
				{
					$('#daySelected').css('border-color', 'red');
				}
				else {
					$('#daySelected').css('border-color', '');
					isValid = true;
				}
				break;
			case 'D':
				// check start date
				if (!$('#startDate').val()) {
					$('#startDate').css('border-color', 'red');
				}
				else {
					$('#startDate').css('border-color', '');
				}
				// check end date
				if (!$('#endDate').val()) {
					$('#endDate').css('border-color', 'red');
				}
				else {
					$('#endDate').css('border-color', '');
				}

				isValid = $('#startDate').val() && $('#endDate').val();
				break;
			case 'W':
				// check start week
				if (!$('#startWeek').val()) {
					$('#startWeek').css('border-color', 'red');
				}
				else {
					$('#startWeek').css('border-color', '');
				}
				// check end week
				if (!$('#endWeek').val()) {
					$('#endWeek').css('border-color', 'red');
				}
				else {
					$('#endWeek').css('border-color', '');
				}

				isValid = $('#startWeek').val() && $('#endWeek').val();
				break;
			case 'M':
				// check start month
				if (!$('#startMonth').val()) {
					$('#startMonth').css('border-color', 'red');
				}
				else {
					$('#startMonth').css('border-color', '');
				}
				// check end week
				if (!$('#endMonth').val()) {
					$('#endMonth').css('border-color', 'red');
				}
				else {
					$('#endMonth').css('border-color', '');
				}

				isValid = $('#startMonth').val() && $('#endMonth').val();
				break;
		}
		return isValid;
	}
});