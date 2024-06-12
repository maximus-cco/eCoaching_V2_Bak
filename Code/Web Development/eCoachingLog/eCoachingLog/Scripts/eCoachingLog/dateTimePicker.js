$(function () {
	// followup dates range
	var minDate = moment().add(1, 'days').millisecond(0).second(0).minute(0).hour(0);
	var maxDate = moment().add(30, 'days').millisecond(0).second(0).minute(0).hour(0);

	// no calendar icon
	$('.date-no-manual-input').datetimepicker({
		format: 'MM/DD/YYYY',
		maxDate: 'now'
	});

	// with calendar icon
	$(".date").datetimepicker({
		allowInputToggle: true,
		format: 'MM/DD/YYYY',
		maxDate: 'now'
	});

	$('body').on('keydown', '.date-no-manual-input, #ReturnToSiteDate', function (e) {
		e.preventDefault();
		return false;
	});

	$('#followup-date').datetimepicker({
		format: 'MM/DD/YYYY',
		minDate: minDate,
		maxDate: maxDate,
		useCurrent: false
	});

	$('#coach-date').datetimepicker({
	    format: 'MM/DD/YYYY',
	    maxDate: 'now',
		useCurrent: false
	});

	$('#ReturnToSiteDate').datetimepicker({
		format: 'MM/DD/YYYY',
		minDate: minDate,
		//maxDate: maxDate,
		useCurrent: false
	});

	$('body').on('keydown', '#followup-date, #coach-date', function (e) {
		e.preventDefault();
		return false;
	});

	//if ($('#followup-date').length && typeof followupDueDate !== "undefined") {
	//	$('#followup-date').val(followupDueDate);
	//}
})