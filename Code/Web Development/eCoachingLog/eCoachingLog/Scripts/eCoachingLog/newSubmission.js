$(function () {
	var cancelBtnClicked = false;
	var workAtHomeChecked = false;
	var showWorkAtHomeBehaviorDiv = false;
	var pfdChecked = false;
	var claimsViewChecked = false;

	const claimsViewErrMsg = '"Claims View" is for Medicare only. You selected a non-medicare program.';

    // https://github.com/istvan-ujjmeszaros/bootstrap-duallistbox/issues/110
	$(document).on('keyup', ".bootstrap-duallistbox-container .filter", function () {
	    //console.log('keyup');
	    $(this).blur();
	    $(this).focus();
	});

	// Check unsaved data
    $('#new-submission-form').data('serialize', $('#new-submission-form').serialize());
    $(window).on('beforeunload', function (e) {
    	if (!cancelBtnClicked) { // Going to a different page
    		if ((errorOccured === false && sessionExpired === false && loggingOut === false && $('#new-submission-form').serialize() != $('#new-submission-form').data('serialize'))
				|| validationError === 'True' && checkPageDataChanged === true) {
    			return 'Your submission has NOT been saved yet. If you choose "Leave this page", you will loose all your entries.';
    		}
    	}
    	else {
    		e = null;
    	}
    });

    if ($('#select-employee').val() > 0) {
        DisplayMgtInfo($('#select-employee').val());
    }

    const textAreaMaxLength = 3000;
    if ($('#textarea-behavior-detail').is(':visible')) {
        var textLength = textAreaMaxLength - $('#textarea-behavior-detail').val().length;
        $('#behavior-detail-remaining').html(textLength + ' remaining');
    }

    if ($('#textarea-action-plan').is(':visible')) {
        var textLength = textAreaMaxLength - $('#textarea-action-plan').val().length;
        $('#action-plan-remaining').html(textLength + ' remaining');
    }


    if (clientValidateEmployee === 'True') {
        if ($('[name="duallistbox_employee"]').length > 0 && $('[name="duallistbox_employee"]').val().length < 1) {
            $("#bootstrap-duallistbox-selected-list_duallistbox_employee").css('border-color', 'red');
        }
    }

    if (clientValidateCoachingReasons === 'True') {
        validateCoachingReasons();
    }

    if ($('#ReturnToSite').val() && $('#ReturnToSite').val().indexOf('Select') > -1) {
    	$('#input-return-site-readonly').val('');
    }
    else {
    	$('#input-return-site-readonly').val($('#ReturnToSite').val());
    }

    $('body').on('change', '#select-program', function () {
        // handle program related reasons
        var programId = $(this).val();
        if (claimsViewChecked) {
            let reasonValErrorSpan = $('span[data-valmsg-for="CoachingReasons"');
            if (programId == 4 || programId == 2) { // 4: Dual; 2: Medicare
                reasonValErrorSpan.addClass('field-validation-valid').removeClass('field-validation-error').text('');
                $('#btn-submit').removeAttr('disabled');
            } else {
                reasonValErrorSpan.addClass('field-validation-error').removeClass('field-validation-valid').text(claimsViewErrMsg);
                $('#btn-submit').attr('disabled', 'disabled');
            }
        }
    });

    $('body').on('change', '.reason-checkbox', function () {
        var reasonId = $(this).closest('.coaching-reason').find('input:hidden.reason-id').val();
        var isChecked = $(this).is(':checked');
        var reasonDivId = $(this).closest('div').attr("id");
        var reasonIndex = $(this).nextAll('.reasonIndex').first().val();
        $.ajax({
        	type: 'POST',
        	url: handleCoachingReasonClicked,
        	data: { isChecked: isChecked, reasonId: reasonId, reasonIndex: reasonIndex },
        	success: function (result) {
        		$('#' + reasonDivId).html(result);
        	}
        });

		// Work At Home (Return to Site Only)
        if (reasonId == 63)
        {
        	workAtHomeChecked = isChecked;
        }

        // Performance, Feedback, and Development (PFD)
        if (reasonId == 64)
        {
            pfdChecked = isChecked;
        }

        $('#IsWorkAtHomeReturnSite').val(workAtHomeChecked);
        $('#IsPfd').val(pfdChecked);

        // show pfd completed date input
        if (pfdChecked)
        {
            $('#div-pfd-compmlete-date').removeClass('hide');
            $('#div-pfd-compmlete-date').addClass('show');
        }
        else
        {
            $('#div-pfd-compmlete-date').removeClass('show');
            $('#div-pfd-compmlete-date').addClass('hide');
        }

		// show HR text instead editable textarea (behavior)
        if (workAtHomeChecked)
        {
        	showBehaviorForWahReturnToSite();
        }
		// show regular editable textarea (behavior)
        else 
        {
        	showBehaviorEditable();
        }

        // Claims View (Medicare Only)
        // id: TBD, for now use 55 as testing
        if (reasonId == 55) {
            claimsViewChecked = isChecked;
        }
        let reasonValErrorSpan = $('span[data-valmsg-for="CoachingReasons"');
        // Invalid if reason 'Claims View' is selected, program 'Marketplace' (1) or 'NA' (3) is selected.
        let isInvalidReason = reasonId == 55 && claimsViewChecked && ($('#select-program').val() == 1 || $('#select-program').val() == 3);
        if (isInvalidReason) {
            reasonValErrorSpan.addClass('field-validation-error').removeClass('field-validation-valid').text(claimsViewErrMsg);
            $('#btn-submit').attr('disabled', 'disabled');
        } else if (!claimsViewChecked) {
            reasonValErrorSpan.addClass('field-validation-valid').removeClass('field-validation-error').text('');
            $('#btn-submit').removeAttr('disabled');
        }
    });

    function showBehaviorForWahReturnToSite()
    {
    	$('#div-wah-behavior').removeClass('hide');
    	$('#div-wah-behavior').addClass('show');
    	$('#div-none-wah-behavior').removeClass('show');
    	$('#div-none-wah-behavior').addClass('hide');
    }

    function showBehaviorEditable()
    {
        $('#div-wah-behavior').removeClass('show');
        $('#div-wah-behavior').addClass('hide');
        $('#div-none-wah-behavior').removeClass('hide');
        $('#div-none-wah-behavior').addClass('show');
    }

    $('body').on('change', '#ReturnToSite', function () {
    	var returnSite = $('#ReturnToSite').val();
    	if (returnSite.indexOf('Select') > -1) // -- Select a Site --
    	{
    		$('#input-return-site-readonly').val('');
    		return;
    	}

    	var employeeSite = $('#SiteName').val();
    	if (employeeSite && employeeSite !== returnSite)
    	{
    		if (!confirm("You are selecting a return site that is different from the employee site. Would you like to proceed?"))
    		{
    			$('#ReturnToSite').val("-- Select a Site --");
    			$('#input-return-site-readonly').val('');
    			return;
    		}
    	}

    	$('#input-return-site-readonly').val($('#ReturnToSite').val());
    })

    //$('body').on('change', '#ReturnToSiteDate', function () {
    //	var thisDate = moment($(this).val(), "M/D/YYYY", true);
    //	// Reset if invalid or before min date or after max date
    //	if (!thisDate.isValid()) {
    //		$(this).val("");
    //	}
    //})

    // Reset page 
    $('body').on('change', '#select-log-module', function () {
        resetPage($("#select-log-module").val());
    });

    // Populate Employee dropdown based on the site selected
    // Also need to reset page (except for the module dropdown, 
    // since at this time, module has been selected)
    $('body').on('change', '#select-site', function () {
        // Show spinner
    	$(".please-wait").slideDown(500);

    	$("#SiteName").val($("#select-site option:selected").text());
        $.ajax({
            type: 'POST',
            url: handleSiteChangedUrl,
            data: { siteIdSelected: $(this).val(), programIdSelected: $('#select-program').val(), programName: $('#ProgramName').val() },

            success: function (result) {
                $(".please-wait").slideUp(500);
                $('#success-message').empty();
                $('#fail-message').empty();
                $('#div-new-submission-main').html(result);
            }
        });
    });

    $('body').on('change', '#select-employee', function () {
        // Display Supervisor and Manger names
        DisplayMgtInfo($(this).val());

        if ($('#select-program').val() > 0 || $('#select-behavior').val() > 0
				// moduleId 4 (LSA): no program dropdown
				|| ($("#select-log-module").val() == MODULE_LSA && $('#select-employee').val() > 0)) {
            // Reset IsCoachingByYou div
            resetIsCoachingByYou();
            $('#div-new-submission-middle').removeClass('hide');
            $('#div-new-submission-middle').addClass('show');
            // Empty page bottom
            $('#div-new-submission-bottom').empty();
        }
    });

    function DisplayMgtInfo(employeeId) {
        $.ajax({
            type: 'POST',
            url: getMgtInfo,
            data: { employeeId: employeeId },
            success: function (result) {
                // Get supervisor info from hidden fields
                $("#div-management").removeClass("hide");
                $("#div-supervisor-name").html(result.SupervisorName);
                $("#div-manager-name").html(result.ManagerName);
            }
        });
    }

    $('body').on('change', '#select-program', function () {
    	// Set hidden field ProgramName
    	$("#ProgramName").val($(this).find("option:selected").text());
        if ($('#select-employee').val() && $('#select-employee').val() !== "-2") {
            $('#div-new-submission-middle').removeClass('hide');
            $('#div-new-submission-middle').addClass('show');
        }
    });

    $('body').on('change', '#select-behavior', function () {
    	// Set hidden field BehaviorName
    	$("#BehaviorName").val($(this).find("option:selected").text());
        if ($('#select-employee').val() != "-2") {
            $('#div-new-submission-middle').removeClass('hide');
            $('#div-new-submission-middle').addClass('show');
        }
    });

    function resetIsCoachingByYou() {
        $.ajax({
            type: 'POST',
            url: resetIsCoachingByYouUrl,
            data: {},
            success: function (result) {
                $('#div-new-submission-middle').html(result);
            }
        });
    }

    function resetPageBottom(isCoachingByYou, isCse, isWarning) {
        var employeeId = $('#select-employee').val();
        var programId = $('#select-program').val();
        $.ajax({
            type: 'POST',
            url: resetPageBottomUrl,
            data: {
                //employeeId: employeeId,
                //programId: programId,
                isCoachingByYou: isCoachingByYou,
                isCse: isCse,
                isWarning: isWarning,
                employeeIds: $("#EmployeeIds").val()
            },
            success: function (result) {
                $('#div-new-submission-bottom').removeClass('hide');
                $('#div-new-submission-bottom').addClass('show');
                $('#div-new-submission-bottom').html(result);
            }
        });
    }

    $('body').on('change', '#IsWarning', function () {
        $('#IsWorkAtHomeReturnSite').val(false);

        if ($("input[name='IsWarning']:checked").val() === 'true') {
            $('#WarningYesNo').val('yes');
            if ($('[name="duallistbox_employee"]').length > 0) {
                if ($('[name="duallistbox_employee"]').val().length > maxEmployeesWarningPerSubmission) {
                    $('#div-max-warning').removeClass('hide');
                    $('#div-max-coaching').addClass('hide');
                } else {
                    $('#div-max-warning').addClass('hide');
                }
            }
        } else {
            $('#WarningYesNo').val('no');
            $('#div-max-warning').addClass('hide');
            if ($('[name="duallistbox_employee"]').val().length > maxEmployeesCoachingPerSubmission) {
                $('#div-max-coaching').removeClass('hide');
            } else {
                $('#div-max-warning').addClass('hide');
            }
        }

    	var isCoachingByYou = $("input[name='IsCoachingByYou']:checked").val()
    	resetPageBottom(isCoachingByYou, false, $(this).val());
    });

    $('body').on('change', "#select-warning-type", function () {
        var valueSelected = $(this).val();
        var actionUrl = loadWarningReasonsUrl;
        $.ajax({
            type: 'POST',
            url: actionUrl,
            data: { warningTypeId: valueSelected },
            success: function (warningReasonSelectList) {
                $("#select-warning-reason").empty();
                // Load warning reason drowdown
                var options = [];
                $.each(warningReasonSelectList, function (i, wr) {
                    options.push('<option value="', wr.Value, '">' + wr.Text + '</option>');
                });
                $("#select-warning-reason").html(options.join(''));
            }
        });
    });

    $('body').on('change', 'input[name="IsCoachingByYou"]', function () {
        var isCoachingByYou = $(this).val();
        var isCse = false;
        var isWarning = false;

        resetPageBottom(isCoachingByYou, isCse, isWarning);
    });

    $('body').on('change', "#IsCse", function () {
    	// reset behavior to editable textarea
    	workAtHomeChecked = false;
    	showWorkAtHomeBehaviorDiv = false;
    	showBehaviorEditable();
		// reset coaching reasons
        refreshCoachingReasons($("input[name='IsCoachingByYou']:checked").val(), $(this).val());
    });

    $('body').on('change', '#IsCallAssociated', function () {
        var yes = $(this).val();
        if (yes === 'true') {
            $('#div-is-call-related').removeClass('hide');
            $('#div-is-call-related').addClass('show');
        }
        else {
            $('#div-is-call-related').removeClass('show');
            $('#div-is-call-related').addClass('hide');
        }
    });

    $('body').on('change', '#IsFollowupRequired', function () {
    	var yes = $(this).val();
    	if (yes === 'True') {
    		// reset followup date
    		$('#followup-date').val('');
    		$('#div-is-followup-required').removeClass('hide');
    		$('#div-is-followup-required').addClass('show');
    	}
    	else {
    		$('#div-is-followup-required').removeClass('show');
    		$('#div-is-followup-required').addClass('hide');
    	}
    });
    // Behavior detail textarea remaining characters display
    $('body').on('keyup', '#textarea-behavior-detail', function (e) {
        var remaining = textAreaMaxLength - $(this).val().length;
        $('#behavior-detail-remaining').text(remaining + ' remaining');
    });

    // Action plan textarea remaining characters display
    $('body').on('keyup', '#textarea-action-plan', function () {
        var textLength = textAreaMaxLength - $(this).val().length;
        $('#action-plan-remaining').text(textLength + ' remaining');
    });

    function refreshCoachingReasons(isCoachingByYou, isCse) {
    	$(".please-wait").slideDown(500);
        // ajax call to get coaching reasons
        $.ajax({
            type: 'POST',
            url: loadCoachingReasonsUrl,
            data: {
                isCoachingByYou: isCoachingByYou,
                isCse: isCse
            },
            success: function (result) {
            	$(".please-wait").slideUp(500);
                $('#coaching-reasons').html(result);
            }
        });
    }

    function resetPage(moduleId) {
    	$(".please-wait").slideDown(500);
    	$('#success-message').empty();
    	$('#fail-message').empty();
        $.ajax({
            type: 'POST',
            url: resetPageUrl,
            data: { moduleId: moduleId },

            success: function (result) {
            	$(".please-wait").slideUp(500);
                $('#div-new-submission-main').html(result);
            }
        });
    }

    function LoadEmployeeDropdown(actionUrl, selected) {
        $.ajax({
            type: 'POST',
            // Call actionUrl method.
            url: actionUrl,
            dataType: 'json',
            // Pass the value of selected to the actionUrl method
            data: { id: selected },

            success: function (employees) {
                $("#select-employee").empty();
                // Load Employee drowdown
                var options = [];
                $.each(employees, function (i, employee) {
                    options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
                });
                $("#select-employee").html(options.join(''));
                $("#select-employee").removeClass('loadinggif');
            }
        });
    }

    $('body').on('click', '#btn-submit', function (e) {
        e.preventDefault();

        $('#btn-submit').prop('disabled', true);
        $('#new-submission-form').data('serialize', $('#new-submission-form').serialize());
        // Remove the beforeunload event
        $(window).off('beforeunload');

        var employees = "";
        var total = 0;
        $("#bootstrap-duallistbox-selected-list_duallistbox_employee option").each(function () {
            employees += $(this).text() + "<br />";
            total++;
        });

        var body = "";
        var footer = "";
        if (total > 0) {
            var max = maxEmployeesCoachingPerSubmission;
            var log = "<font color='green'> coaching log </font>";
            var isWarning = false;
            if ($('input[name=IsWarning]:checked').val() === "true") {
                max = maxEmployeesWarningPerSubmission;
                log = "<font color='red'> warning log </font>";
                isWarning = true;
            }

            if (total > max) {
                body = "You selected " + total + " employees.<br/>The maximum number of employees for " + log + " in one submission is " + max + ".";
                footer = '<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>';
            } else {
                if (isWarning === true) {
                    body = "<b>A new" + log + "will be created for</b> " + employees + "<br /><b>Do you wish to continue?</b>";
                } else {
                    body = "<b>A new" + log + "will be created for each of the following:</b><br />" + employees + "<br /><b>Do you wish to continue?</b>";
                }
                footer = '<button type="button" class="btn btn-primary" id="btn-modal-yes">Yes</button>' +
                    '<button type="button" class="btn btn-default" data-dismiss="modal">No</button>';
            }

            $('#btn-submit').prop('disabled', false);
            $('#modal-confirm-container .modal-content').html(
            '<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">New Submission</h4></div>' +
            '<div class="modal-body"><p>' + body + '</p></div>' +
            '<div class="modal-footer">' + footer + '</div>');
            $('#modal-confirm-container').modal();
            return;
        }

        $(".please-wait").slideDown(500);
        $('#new-submission-form').submit();
    });

    $('body').on('click', '#btn-modal-yes', function (e) {
        $('#modal-confirm-container').modal('hide');
        //$('#new-submission-form').data('serialize', $('#new-submission-form').serialize());
        //$(window).off('beforeunload');
        $(".please-wait").slideDown(500);
        $('#new-submission-form').submit();
    })
    $('body').on('click', '#btn-cancel', function (e) {
    	if (confirm("Are you sure you want to cancel this submission?\nIf you select OK, you will loose all your entries.")) {
    		cancelBtnClicked = true;
        	$(".please-wait").slideDown(500);
			// Don't check if page data has changed, just cancel the form
        	checkPageDataChanged = false;
            window.location.href = redirectToIndex;
        }
        else {
            return false;
        }
    });

    $('body').on('click', '#a-add-employee', function (e) {
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;
            $(".please-wait").slideDown(500);
            $.ajax({
                type: 'POST',
                url: initAddEmployeeUrl,
                dataType: 'html',
                data: { excludeSiteId: $('#select-site').val() },
                success: function (data) {
                    $('#modal-container .modal-content').html(data);
                    $('#modal-container').modal();
                    $('#modal-container').modal('handleUpdate');
                },
                complete: function () {
                    $(".please-wait").slideUp(500);
                }
            });
        }
    });
    
    $('body').on('change', '#add-employee-select-site', function () {
        if ($(this).val() != -2) {
            $(this).css('border-color', '');
        }
        ReloadEmployees($('#add-employee-select-employee'));
    });

    $('body').on('change', '#add-employee-select-employee', function () {
        if ($(this).val() != -2) {
            $(this).css('border-color', '');
        }
    });

    function ReloadEmployees(employeeDropdown) {
        employeeDropdown.addClass('loadinggif');
        $.getJSON(getEmployeesUrl, {
            siteId: $('#add-employee-select-site').val()
        })
		.done(function (employees) {
		    var options = [];
		    $.each(employees, function (i, employee) {
		        options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
		    });
		    employeeDropdown.html(options.join(''));
		})
		.fail(function () {
		    employeeDropdown.html('<option value="">error ...&nbsp;&nbsp;</option>');
		})
		.always(function () {
		    employeeDropdown.removeClass('loadinggif')
		});
    }

    function validateCoachingReasons() {
        var coachingReasons = $('#coaching-reasons').find('.reason-checkbox:checkbox');
    	// Skip coaching reasons client validation if no reasons displayed
        if (coachingReasons.length === 0) {
            return true;
        }
        var errorMessage = 'At least one coaching reason must be selected.';
        var reasonValErrorSpan = $('span[data-valmsg-for="CoachingReasons"');
        var selectedCoachingReasons = coachingReasons.filter(':checked');

    	// reason-checkbox
        var isValid = selectedCoachingReasons.length >= 1;
        if (!isValid) {
            reasonValErrorSpan.addClass('field-validation-error').removeClass('field-validation-valid').text(errorMessage);
        } else {
            reasonValErrorSpan.addClass('field-validation-valid').removeClass('field-validation-error').text('');
            selectedCoachingReasons.each(function () {
                // validate associated radio buttons (opportunity, enhancement), and multiselect (sub reasons)
                var isValidOpp = validateOpportunity($(this));
                var isValidSub = validateSubReasons($(this));
                isValid = isValid && isValidOpp && isValidSub;
            });

            if (selectedCoachingReasons.length > 12) {
            	errorMessage = 'Maximum number of selected coaching reasons is 12.';
            	reasonValErrorSpan.addClass('field-validation-error').removeClass('field-validation-valid').text(errorMessage);
            }
        }
        return isValid;
    }

    function validateOpportunity(target) {
    	var errorElement = target.nextAll('.validation-value').first().find('span[data-valmsg-for="IsOpportunity"]');
        var errorMessage = 'Please make a selection.'
        var isValid = target.nextAll('.coaching-values').find('input:radio[name*="IsOpportunity"]').is(':checked');
        if (!isValid) {
            errorElement.addClass('field-validation-error').removeClass('field-validation-valid').text(errorMessage);
        } else {
            errorElement.addClass('field-validation-valid').removeClass('field-validation-error').text('');
        }
        return false;
    }

    function validateSubReasons(target) {
        var errorMessage = 'Please select at least one sub reason.';
        var errorElement = target.nextAll('.coaching-subreasons').first().find('span[data-valmsg-for="SubReasonIds"]');
        var $subReasons = target.nextAll('.coaching-subreasons').first();
        var selectedSubReasons = $subReasons.find(':selected').length;
        var isValid = selectedSubReasons >= 1;
        if (!isValid) {
            errorElement.addClass('field-validation-error').removeClass('field-validation-valid').text(errorMessage);
        } else {
            errorElement.addClass('field-validation-valid').removeClass('field-validation-error').text('');
        }
        return isValid;
    }
});

