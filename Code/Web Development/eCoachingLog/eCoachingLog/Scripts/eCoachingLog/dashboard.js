$(document).ready(function () {
	// Show how many pendings on page inital display
	if (typeof showPendingText !== 'undefined' && showPendingText === true)
	{
		$.notify({
			title: '<strong>Attention: </strong>',
			message: 'You have <span class="lead">' + totalPending + '</span> pending logs that require your action.',
			icon: 'glyphicon glyphicon-info-sign',
		},
		{
			type: 'info',
			delay: 10000, // 10 seconds
			placement: {
				from: "bottom",
				align: "right"
			},
			offset: {
				x: 20,
				y: 20
			},
			animate: {
				enter: 'animated fadeInUp',
				exit: 'animated fadeOutDown'
			},
			mouse_over: 'pause',
		});
	}

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
				data: { logId: $(this).data("log-id"), isCoaching: $(this).data("is-coaching") },
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

	// onclick "Is the coaching opportunity a confirmed Customer Service Escalation (CSE)?"
	$('body').on('change', '#IsCse', function () {
		toggleCse($(this).val());
	});

	// onclick "Based on your research does this record require coaching?"
	$('body').on('change', '#IsCoachingRequired', function () {
		toggleCoachingRequired($(this).val());
	});

	$('body').on('click', '.my-dashboard-log-list', function (e) {
		e.preventDefault();

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				url: getLogListUrl,
				data: { whatLog: $(this).data("log") },
				success: function (data) {
					$(".please-wait").slideUp(500);
					$('#div-log-list').html(data);
				}
			});
		}
	});

	$('body').on('click', '#a-close', function (e) {
		$('#coaching-log-list').hide();
	});

	// My Dashboard (Director) - Month changed
	$('body').on('change', '#ddl-month', function (e) {
		e.preventDefault();

		$(".please-wait").slideDown(500)
		$.ajax({
			type: 'POST',
			url: getDataByMonth,
			data: { month: $('#ddl-month').val() },
			success: function (data) {
				$(".please-wait").slideUp(500);
				$('#div-dashboard-director').html(data);
			}
		});
	});
	
	// My Dashboard (Director) - "Site" link clicked
	$('body').on('click', '.my-dashboard-log-list-by-site', function (e) {
		e.preventDefault();

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				url: getLogListUrl,
				data: {
					whatLog: $(this).data("log-type"),
					siteId: $(this).data("site-id"),
					siteName: $(this).data("site-name"),
					month: $('#ddl-month').val()
				},
				success: function (data) {
					$(".please-wait").slideUp(500);
					$('#div-search-result-director').removeClass('hide');
					$('#div-search-result-director').addClass('show');
					$('#div-log-list').html(data);
				}
			});
		}
	});

	$('body').on('change', '.log-type', function (e) {
		$('input[name=typeSelected').val($(this).val());
	});

	// Search log
	$('body').on('click', '#btn-search', function (e) {
		e.preventDefault();
		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			var pageSizeSelected = {
				pageSizeSelected: $('input[name=pageSizeSelected').val()
			};
			$.ajax({
				type: 'POST',
					url: searchUrl,
					data: $('#form-search-mydashboard').serialize() + '&' + $.param(pageSizeSelected),
				success: function (data) {
					$(".please-wait").slideUp(500);
					// Warning logs not allowed to export
					if ($('input[name=typeSelected').val() === 'MySiteWarning')
					{
						$('#btn-export-excel-director').hide();
					}
					else {
						$('#btn-export-excel-director').show();
					}
					$('#div-search-result').html(data);
				}
			});
		}
	});

	// Export to excel - historical
	$('body').on('click', '#btn-export-excel', function (e) {
		e.preventDefault();
		// Prevent multiple clicks
		$(this).prop('disabled', true);

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				url: exportToExcelUrl,
				data: $('#form-search-historical').serialize(),
				success: function (data) {
					// clean up
					$('#btn-export-excel').prop('disabled', false);
					$(".please-wait").slideUp(500);

					if (data.result === 'ok')
					{
						window.location = downloadExcelUrl;
					}
					else if (data.result === 'hugedata') {
						alert('You have reached the maximum number of records (6k) that can be exported at a time. Please refine your filters and try again.');
					}
					// fail
					else {
						alert('Something went wrong while trying to export logs to excel file. Please refine your filters and try again.');
					}
				}
			});
		}
	});

	// Export to excel - my dashboard/director
	$('body').on('click', '#btn-export-excel-director', function (e) {
		e.preventDefault();
		// Prevent multiple clicks
		$(this).prop('disabled', true);

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				url: exportToExcelUrl,
				data: $('#form-search-mydashboard').serialize(),
				success: function (data) {
					// clean up
					$('#btn-export-excel-director').prop('disabled', false);
					$(".please-wait").slideUp(500);
					// excel generated
					if (data.result === 'ok') {
						// download the generated excel file
						window.location = downloadExcelUrl;
					}
					// too much data
					else if (data.result === 'hugedata') {
						alert('You have reached the maximum number of records (100,000) that can be exported at a time. Please refine your filters and try again.');
					}
					// fail
					else {
						alert('Something went wrong while trying to export logs to excel file. Please refine your filters and try again.');
					}
				}
			});
		}
	});

    $('body').on('click', '#btn-submit', function (e) {
    	e.preventDefault();
    	$(this).prop('disabled', true);
    	submitReview(saveUrl, myTable);
    });

    function submitReview(url, tableToRefresh) {
    	// Do not send input fields in hidden div (display:none) to server
    	$('div:hidden :input').prop("disabled", true);

    	var request = $.ajax({
    		type: 'POST',
    		url: url,
    		data: $('#form-mydashboard-review-pending').serialize(),
    		dataType: 'json'
    	});

    	request.always(function (data) {
    		$(".please-wait").slideUp(500); // Hide spinner
    	});

    	request.done(function (data) {
    		if (data.valid === false)
    		{
    			$('#btn-submit').prop('disabled', false);
    			$('#div-error-prompt').html('<br />Please correct the error(s) and try again.');

				// Reset all error msgs
    			$.each(data.allfields, function (i, field) {
    				$('#' + field).removeClass('errorClass');
    				container = $('span[data-valmsg-for="' + field + '"]').html('');
    			});

				// Display error msgs
    			$.each(data.errors, function (key, value) {
    				var container = $('span[data-valmsg-for="' + key + '"]');
    				container.removeClass("field-validation-valid").addClass("field-validation-error");
    				container.html(value);

    				$('#' + key).addClass('errorClass');
    			});
    		}
    		else
    		{
    			if (data.success === true) {
    				$('#modal-container').modal('hide');
    				// Refresh log list, server side LoadData gets called
    				tableToRefresh.ajax.reload();
    				//// Update count display
    				//$countToUpdate.html(data.count);
    				// Display success message
    				$.notify({
    					message: data.successMsg,
						icon: 'glyphicon glyphicon-saved',
    				},
					{
						type: 'success',
						delay: 6000, // 6 seconds
    					placement: {
    						from: "bottom",
							align: "right"
    					},
    					offset: {
    						x: 30,
    						y: 10
    					},
    					animate: {
    						enter: 'animated fadeInUp',
    						exit: 'animated fadeOutDown'
    					},
    					mouse_over: 'pause',
    				});
    			}
    			else {
    				$('#modal-container').modal('hide');
					// Display error message
    				$.notify({
    					message: data.errorMsg,
    					icon: 'glyphicon glyphicon-warning-sign',
    				},
					{
						type: 'danger',
						delay: 10000, // 10 seconds
						placement: {
							from: "bottom",
							align: "right"
						},
						offset: {
							x: 30,
							y: 10
						},
						animate: {
							enter: 'animated fadeInUp',
							exit: 'animated fadeOutDown'
						},
    					mouse_over: 'pause',
					});
    			}
    		}
    	});
    }

    function toggleCse(cseSelected) {
    	$('div:hidden :input').prop("disabled", false);

    	resetValidationErrors();

    	if (cseSelected === 'true') {
    		// Show 'Enter the date coached:'
    		// Hide 'Enter the date reviewed:'
    		$('#div-date-coached').removeClass('hide');
    		$('#div-date-reviewed').removeClass('show');
    		$('#div-date-reviewed').addClass('hide');
    		// Show 'Provide the details from the coaching session including action plans developed:'
    		// Hide 'Provide explanation for Employee and Supervisor as to reason why this is not a CSE:'
    		$('#div-coaching-detail').removeClass('hide');
    		$('#div-why-not-cse').removeClass('show');
    		$('#div-why-not-cse').addClass('hide');
    	}
    	else {
    		// Hide 'Enter the date coached:'
    		// Show 'Enter the date reviewed:'
    		$('#div-date-reviewed').removeClass('hide');
    		$('#div-date-coached').removeClass('show');
    		$('#div-date-coached').addClass('hide');
    		// Hide 'Provide the details from the coaching session including action plans developed:'
    		// Show 'Provide explanation for Employee and Supervisor as to reason why this is not a CSE:'
    		$('#div-why-not-cse').removeClass('hide');
    		$('#div-coaching-detail').removeClass('show');
    		$('#div-coaching-detail').addClass('hide');
    	}
    }

    function resetValidationErrors() {
    	$('#div-error-prompt').html('');

    	// reset error msg
    	$("form :input:visible").each(function () {
    		$(this).removeClass('errorClass');
    		var field = $(this).attr("id");
    		var errorMsg = $('span[data-valmsg-for="' + field + '"]').text();
    		if (errorMsg) {
    			$('span[data-valmsg-for="' + field + '"]').html('');
    		}
    	});
    }

    function toggleCoachingRequired(coachingRequired) {
    	$('div:hidden :input').prop("disabled", false);

    	resetValidationErrors();

    	if (coachingRequired === 'true') {
    		// show
    		$('#div-coachable-detail-reason').removeClass('hide');
    		// hide
    		$('#div-noncoachable-main-reason').removeClass('show');
    		$('#div-noncoachable-main-reason').addClass('hide');
    		$('#div-noncoachable-detail-reason').removeClass('show');
    		$('#div-noncoachable-detail-reason').addClass('hide');
    	}
    	else {
    		// show
    		$('#div-noncoachable-main-reason').removeClass('hide');
    		$('#div-noncoachable-main-reason').addClass('show');
    		$('#div-noncoachable-detail-reason').removeClass('hide');
    		$('#div-noncoachable-detail-reason').addClass('show');
    		// hide
    		$('#div-coachable-detail-reason').removeClass('show');
    		$('#div-coachable-detail-reason').addClass('hide');
    	}
    }
});


