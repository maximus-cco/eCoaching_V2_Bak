$(function () {
	// date picker
	$('.date').datetimepicker({
		allowInputToggle: true,
		format: 'MM/DD/YYYY',
		maxDate: 'now'
	});

	// linked date picker
	$("#datePickerStart").on("dp.change", function (e) {
		$('#datePickerEnd').data("DateTimePicker").minDate(e.date);
	});
	$("#datePickerEnd").on("dp.change", function (e) {
		$('#datePickerStart').data("DateTimePicker").maxDate(e.date);
	});

	// month picker
	$('[class*="monthPicker"]').datetimepicker({
		allowInputToggle: true,
		format: 'MM/YYYY',
		viewMode: 'months',
		maxDate: 'now'
	});
	// linked month picker
	$("#monthPickerStart").on("dp.change", function (e) {
		$('#monthPickerEnd').data("DateTimePicker").minDate(e.date);
	});
	$("#monthPickerEnd").on("dp.change", function (e) {
		$('#monthPickerStart').data("DateTimePicker").maxDate(e.date);
	});

	// week picker
	$('[class*="weekPicker"]').datetimepicker({
		allowInputToggle: true,
		format: 'MM/DD/YYYY',
		maxDate: 'now'
	});
	// linked week picker
	$("#weekPickerStart").on("dp.change", function (e) {
		$('#weekPickerEnd').data("DateTimePicker").minDate(e.date);
	});
	$("#weekPickerEnd").on("dp.change", function (e) {
		$('#weekPickerStart').data("DateTimePicker").maxDate(e.date);
	});
	$('.weekPickerStart').on('dp.change', function (e) {
		var value = $("#startWeek").val();
		var sunday = moment(value, "MM/DD/YYYY").day(0).format("MM/DD/YYYY");
		//var saturday = moment(value, "MM/DD/YYYY").day(6).format("MM/DD/YYYY");
		$("#startWeek").val(sunday);
	});
	$('.weekPickerEnd').on('dp.change', function (e) {
		var value = $("#endWeek").val();
		var sunday = moment(value, "MM/DD/YYYY").day(0).format("MM/DD/YYYY");
		$("#endWeek").val(sunday);
	});

	$('body').on('keydown', '.date, [class*="weekPicker"], [class*="monthPicker"]', function (e) {
		e.preventDefault();
		return false;
	});
})