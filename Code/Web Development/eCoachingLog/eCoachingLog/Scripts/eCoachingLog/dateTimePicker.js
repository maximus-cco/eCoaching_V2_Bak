$(function () {
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

	$('body').on('keydown', '.date-no-manual-input', function (e) {
		e.preventDefault();
		return false;
	});

	// Overrides jquery date validator
    jQuery.validator.methods.date = function (value, element) {
    	return moment(value, ["MM/DD/YYYY"], true).isValid();
    };
})