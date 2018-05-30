$(document).ready(function () {
	$('#div-success-msg').hide();
	$('#div-error-msg').hide();

	// Display Review Modal
	$('body').on('click', '.modal-link', function (e) {
		//http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
		e.preventDefault();
		if (e.handled !== true) {
			e.handled = true;
			//console.log("!!!Get Detail!!!");
			$.ajax({
				type: 'POST',
				// Call GetLogDetail method.
				url: getLogDetailsUrl,
				dataType: 'html',
				data: { logId: $(this).data("log-id"), isCoaching: $(this).data("is-coaching") },

				success: function (data) {
					$('.modal-content').html(data);
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
				data: { whatLog: $(this).data("log") },
				success: function (data) {
					$(".please-wait").slideUp(500);
					$('#div-log-list').html(data);
				}
			});
		}
	});

	// Search log
	$('body').on('click', '#btn-search', function (e) {
		e.preventDefault();

		//if (!validateMyDashboardSearch()) {
		//	return;
		//}

		alert(searchUrl);

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
					url: searchUrl,
					data: $('#form-search-mydashboard').serialize(),
				success: function (data) {
					$(".please-wait").slideUp(500);
					//$('#div-search-result').removeClass('hide');
					//$('#div-search-result').addClass('show');
					$('#div-search-result').html(data);
				}
			});
		}
	});

	// Export to excel
	$('body').on('click', '#btn-export-excel', function (e) {
		e.preventDefault();

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			// DataTables search box
			var $searchBox = $('#dataTables-coaching-log-list_filter').find('input.form-control');
			var searchObj = {
				searchText: $searchBox.val()
			};
			$.ajax({
				type: 'POST',
				url: exportToExcelUrl,
				data: $('#form-search-historical').serialize() + '&' + $.param(searchObj),
				success: function (data) {
					if (data.result === 'ok')
					{
						window.location = downloadExcelUrl;
					}
					else {
						alert('There was an error when exporting to excel file.');
					}
					$(".please-wait").slideUp(500);
				}
			});
		}
	});


	//$('.my-dashboard-log-list').on('click', function (e) {
    //	e.preventDefault();

    //	if (e.handled !== true) {
    //        e.handled = true;
	//        $(".please-wait").slideDown(500);
    //        $.ajax({
    //            type: 'POST',
    //            url: getLogListUrl,
    //            data: { whatLog: $(this).data("log") },
    //            success: function (data) {
	//            	$(".please-wait").slideUp(500);
	//				$('#div-log-list').html(data);
    //            }
    //        });
    //    }
    //});

    $('body').on('click', '#btn-submit', function (e) {
    	e.preventDefault();
    	$(this).prop('disabled', true);
		// Show spinner
    	$(".please-wait").slideDown(500);
    	//console.log("submitReview");
    	submitReview(saveUrl, myTable, $('#my-pending-total'));
    });

    function validateMyDashboardSearch()
    {
    	return true;
    }

    function submitReview(url, tableToRefresh, $countToUpdate) {
    	// Do not send hidden input fields (display:none) to server
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
    				//if (value) {
    				//alert('key=' + key);
    				//alert('value=' + value);
    					var container = $('span[data-valmsg-for="' + key + '"]');
    					container.removeClass("field-validation-valid").addClass("field-validation-error");
    					container.html(value);

    					$('#' + key).addClass('errorClass');
    				//}
    			});
    		}
    		else
    		{
    			if (data.success === true) {
    				$('#modal-container').modal('hide');
    				// Refresh log list, server side LoadData gets called
    				tableToRefresh.ajax.reload();
    				// Update count display
    				$countToUpdate.html(data.count);
    				// Display success message
    				$('#label-success-msg').text(data.successMsg);
    				$('#div-success-msg').fadeTo(5000, 500).slideUp(500);
    			}
    			else {
    				$('#modal-container').modal('hide');
					// Display error message
    				$('#label-error-msg').text(data.errorMsg);
    				$('#div-error-msg').fadeTo(8000, 500).slideUp(500);
    			}
    		}
    	});
    }

    function toggleCse(cseSelected) {
    	$('div:hidden :input').prop("disabled", false);

    	resetValidationErrors();

    	if (cseSelected === 'true') {
    		//alert(cseSelected);
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
    		//alert(cseSelected);
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
    		//alert(field);
    		var errorMsg = $('span[data-valmsg-for="' + field + '"]').text();
    		if (errorMsg) {
    			//alert(errorMsg);
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


