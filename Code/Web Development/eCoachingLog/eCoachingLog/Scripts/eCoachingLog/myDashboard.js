$(document).ready(function () {
	// Show how many pendings on page inital display
	if (typeof showPendingText !== 'undefined' && showPendingText === true)
	{
	    var msg = 'You have <span class="lead">' + totalPending + '</span> pending logs that require your action.';
	    showNotification(msg, "glyphicon glyphicon-bell", "info");
	}

	// onclick "Is the coaching opportunity a confirmed Customer Service Escalation (CSE)?"
	$('body').on('change', '#IsConfirmedCse', function () {
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
		var logType = $(this).val();
		$("input[name='typeSelected']").val(logType);
		//if (logType === 'MySiteWarning')
		//{
		//	$('#div-select-status').show();
		//}
		//else {
		//	$('#div-select-status').hide();
		//}
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
					else if (data.result === 'oversized') {
						alert('You have reached the maximum number of records (100,000) that can be exported at a time. Please refine your filters and try again.');
					}
						// fail
					else {
						$('#modal-container .modal-content').html(
							'<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button>Export to Excel</div>' +
							'<div class="modal-body"><p>Something went wrong while trying to export logs to excel file. Please try again at a later time.</p></div>' +
							'<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');
						$('#modal-container').modal();
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

	// Short Call - reload behavior list when valid check box is clicked
	$('body').on('click', 'input[name*="IsValidBehavior"]', function (e) {
		var isValid = $(this).is(':checked');
		var $behaviorDropdown = $(this).parent().next('td').find('select');
		var $actionDiv = $(this).parent().next('td').next('td').find('div');

		$behaviorDropdown.addClass('loadinggif');
		$.getJSON(initShortCallBehaviors, {
			isValid: isValid
		})
		.done(function (behaviors) {
			var options = [];
			$.each(behaviors, function (i, behavior) {
				options.push('<option value="', behavior.Value, '">' + behavior.Text + '</option>');
			});
			$behaviorDropdown.html(options.join(''));
			// Reset Action text to blank
			$actionDiv.html('');
		})
		.fail(function () {
			$behaviorDropdown.html('<option value="">error ...&nbsp;&nbsp;</option>');
		})
		.always(function () {
			$behaviorDropdown.removeClass('loadinggif')
		});
	});

	// Short Call: Update Action column based on Behavior selected
	$('body').on('change', 'select[name*="SelectedBehaviorId"]', function (e) {
		// Action cell
		var $actionDiv = $(this).parent().next('td').find('div');
		var $actionHidden = $(this).parent().next('td').find('input');
		// Valid Checkbox cell
		var $validBehaviorTd = $(this).parent().prev('td').find('input');

		$.getJSON(getEclAction, {
			logId: logId,
			employeeId: employeeId,
			behaviorId: $(this).val(),
			isValidBehavior: $validBehaviorTd.is(':checked')
		})
		.done(function (data) {
			$actionDiv.html(data.eclActionToDisplay);
			$actionHidden.val(data.eclAction);
		})
		.fail(function () {
		})
		.always(function () {
		});
	});

	// Short Call - toggle comments textbox display based on which 'agree' radio button is selected
	$('body').on('click', 'input[name*="IsManagerAgreed"]', function (e) {
		$('div:hidden :input').prop("disabled", false);

		if ($(this).val() === 'true') {
			$(this).parent().next().removeClass('show');
			$(this).parent().next().addClass('hide');
		}

		if ($(this).val() === 'false') {
			$(this).parent().next().removeClass('hide');
			$(this).parent().next().addClass('show');
		}
	});

	$('body').on('click', 'input[type=radio][name=IsFollowupCoachingRequired]', function (e) {
	    var yes = $(this).val();
	    if (yes === 'True') {
	        // reset followup date
	        $('#followup-date').val('');
	        $('#followup-date').prop("disabled", false);
	        $('#div-select-followup-due-date').removeClass('hide');
	        $('#div-select-followup-due-date').addClass('show');
	    }
	    else {
	        $('#div-select-followup-due-date').removeClass('show');
	        $('#div-select-followup-due-date').addClass('hide');
	    }
	});

    // todo: need to figure out what is this for?
	$('body').on('click', 'input[type=radio][name=IsFollowupRequired]', function (e) {
	    if ($(this).val() === 'True') {
	        $('#div-followup-deadline').removeClass('hide');
	        $('#div-followup-deadline').addClass('show');
	    } else {
	        $('#div-followup-deadline').removeClass('show');
	        $('#div-followup-deadline').addClass('hide');
	    }
	})

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
        if (data.valid === false) {
            $('#btn-submit').prop('disabled', false);
            $('#div-error-prompt').html('<br />Please correct the error(s) and try again.');

            // Reset all error msgs
            $.each(data.allfields, function (i, field) {
                $('[name="' + field + '"]').removeClass('errorClass');
                container = $('span[data-valmsg-for="' + field + '"]').html('');
            });

            // Display error msgs
            $.each(data.errors, function (key, value) {
                var container = $('span[data-valmsg-for="' + key + '"]');
                container.removeClass("field-validation-valid").addClass("field-validation-error");
                container.html(value);

                $('[name="' + key + '"]').addClass('errorClass');
            });
        }
        else {
            if (data.success === true) {
                $('#modal-container').modal('hide');
                // Refresh log list, server side LoadData gets called
                tableToRefresh.ajax.reload();
                //// Update count display
                //$countToUpdate.html(data.count);
                // Display success message
                showNotification(data.successMsg, "glyphicon glyphicon-saved", "success");
            }
            else {
                $('#modal-container').modal('hide');
                // Display error message
                showNotification(data.errorMsg, "glyphicon glyphicon-warning-sign", "danger");
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
        $('#div-is-followup-required').removeClass('hide');
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
        $('#div-is-followup-required').removeClass('show');
        $('#div-is-followup-required').addClass('hide');
    }
}





