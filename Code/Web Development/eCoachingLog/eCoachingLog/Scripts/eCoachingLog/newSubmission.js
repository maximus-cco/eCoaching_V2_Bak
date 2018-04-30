$(function () {
	var cancelled = false;

	// Check unsaved data
    $('#new-submission-form').data('serialize', $('#new-submission-form').serialize());
    $(window).on('beforeunload', function (e) {
    	if ((errorOccured === false && sessionExpired === false && loggingOut === false && cancelled === false && $('#new-submission-form').serialize() != $('#new-submission-form').data('serialize'))
			|| validationError === 'True') {
            return 'Your submission has NOT been saved yet. If you choose "Leave this page", you will loose all your entries.';
        }
        else {
            e = null;
        }
    });

    const textAreaMaxLength = 3000;
    if ($('#textarea-behavior-detail').is(':visible')) {
        var textLength = textAreaMaxLength - $('#textarea-behavior-detail').val().length;
        $('#behavior-detail-remaining').html(textLength + ' remaining');
    }

    if ($('#textarea-action-plan').is(':visible')) {
        var textLength = textAreaMaxLength - $('#textarea-action-plan').val().length;
        $('#action-plan-remaining').html(textLength + ' remaining');
    }

    if (clientValidateCoachingReasons === 'True') {
        validateCoachingReasons();
    }

    $('body').on('click', '.coaching-values :radio', function () {
        var isOpportunity = $(this).val();
        var reasonId = $(this).closest('.coaching-reason').find('input:hidden.reason-id').val();
        // Ajax to server to update viewmodel in session
        $.ajax({
            type: 'POST',
            url: handleCoachingValueClicked,
            data: { reasonId: reasonId, isOpportunity: isOpportunity },
            success: function (result) {
                $('#coaching-reasons').html(result);
            }
        })
    });

    $('body').on('change', '.reason-checkbox', function () {
        var reasonId = $(this).closest('.coaching-reason').find('input:hidden.reason-id').val();
        var isChecked = $(this).is(':checked');
        $.ajax({
            type: 'POST',
            url: handleCoachingReasonClicked,
            // TODO: use reasonID instead
            data: { isChecked: isChecked, reasonId: reasonId },
            success: function (result) {
                $('#coaching-reasons').html(result);
            }
        });
    });

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

        $('#flash-message').empty();

        $.ajax({
            type: 'POST',
            url: handleSiteChangedUrl,
            data: { siteIdSelected: $(this).val() },

            success: function (result) {
            	$(".please-wait").slideUp(500);
                $('#div-new-submission-main').html(result);
            }
        });
    });

    $('body').on('change', '#select-employee', function () {
        // Reset flash message
        $('#flash-message').empty();
        // Display Supervisor and Manger names
        DisplayMgtInfo($(this).val());

        if ($('#select-program').val() > 0 || $('#select-behavior').val() > 0) {
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
        if ($('#select-employee').val() > 0) {
            $('#div-new-submission-middle').removeClass('hide');
            $('#div-new-submission-middle').addClass('show');
            resetIsCoachingByYou();
        }
    });

    $('body').on('change', '#select-behavior', function () {
    	// Set hidden field BehaviorName
    	$("#BehaviorName").val($(this).find("option:selected").text());
        if ($('#select-employee').val() > 0) {
            $('#div-new-submission-middle').removeClass('hide');
            $('#div-new-submission-middle').addClass('show');
            resetIsCoachingByYou();
        }
    });

    function resetIsCoachingByYou() {
        //var employeeId = $('#select-employee').val();
        $.ajax({
            type: 'POST',
            url: resetIsCoachingByYouUrl,
            data: {}, //{ employeeId: employeeId },
            success: function (result) {
                $('#div-new-submission-middle').html(result);
            }
        });
    }

    function resetPageBottom(isCoachingByYou, isCse, isWarning) {
        var employeeId = $('#select-employee').val();
        var programId = $('#select-program').val();

        $('#flash-message').empty();
        $.ajax({
            type: 'POST',
            url: resetPageBottomUrl,
            data: {
                //employeeId: employeeId,
                //programId: programId,
                isCoachingByYou: isCoachingByYou,
                isCse: isCse,
                isWarning: isWarning
            },
            success: function (result) {
                $('#div-new-submission-bottom').removeClass('hide');
                $('#div-new-submission-bottom').addClass('show');
                $('#div-new-submission-bottom').html(result);
            }
        });
    }

    $('body').on('change', '#IsWarning', function () {
        var isCoachingByYou = $("input[name='IsCoachingByYou']:checked").val()
        if ($(this).val() === 'true') {
            resetPageBottom(isCoachingByYou, false, true);
        }
        else {
            resetPageBottom(isCoachingByYou, false, false);
        }
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
        $('#flash-message').empty();
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

    $('body').on('submit', '#new-submission-form', function (e) {
		// Just in case to prevent multiple submits
    	$('#btn-submit').prop('disabled', true);

        $('#new-submission-form').data('serialize', $('#new-submission-form').serialize());
        // Remove the beforeunload event
        $(window).off('beforeunload');

        $(".please-wait").slideDown(500);
        var isWarningLog = $('#hdIsWarning').val();
        if (isWarningLog === 'true') {
            // validation is done on server side
            return true;
        }

        return true;
    });

    $('body').on('click', '#btn-cancel', function (e) {
        if (confirm("Are you sure you want to cancel this submission?")) {
        	$(".please-wait").slideDown(500);
            cancelled = true;
            window.location.href = redirectToIndex;
        }
        else {
            cancelled = false;
            return false;
        }
    });

    function validateCoachingReasons() {
        var coachingReasons = $('#coaching-reasons').find('.reason-checkbox:checkbox');
        // Skip coaching reasons client validation if no reasons displayed
        if (coachingReasons.length === 0) {
            return true;
        }
        var errorMessage = 'At least one coaching reason must be selected.';
        var errorElement = $('span[data-valmsg-for="CoachingReasons"');
        var selectedCoachingReasons = coachingReasons.filter(':checked');
    	// reason-checkbox
        var isValid = selectedCoachingReasons.length >= 1;
        if (!isValid) {
            errorElement.addClass('field-validation-error').removeClass('field-validation-valid').text(errorMessage);
        } else {
            errorElement.addClass('field-validation-valid').removeClass('field-validation-error').text('');
            selectedCoachingReasons.each(function () {
                // validate associated radio buttons (opportunity, enhancement), and multiselect (sub reasons)
                var opportunityRadioName = "CoachingReasons[" + $(this).attr('id') + "].IsOpportunity";
                var isValidOpp = validateOpportunity(opportunityRadioName);
                var subReasonMultiSelectId = "#CoachingReasons_" + $(this).attr('id') + "__SubReasonIds";
                var subReasonMultiSelect = $(subReasonMultiSelectId);
                var isValidSub = validateSubReasons(subReasonMultiSelect);
                isValid = isValid && isValidOpp && isValidSub;
            });

            if (selectedCoachingReasons.length > 12) {
            	errorMessage = 'Maximum number of selected coaching reasons is 12.';
            	errorElement.addClass('field-validation-error').removeClass('field-validation-valid').text(errorMessage);
            }
        }
        return isValid;
    }

    function validateOpportunity(opportunityRadioName) {
        var errorElement = $('span[data-valmsg-for="' + opportunityRadioName + '"');
        var errorMessage = 'Please make a selection.'
        var isValid = $('input:radio[name="' + opportunityRadioName + '"]').is(':checked');
        if (!isValid) {
            errorElement.addClass('field-validation-error').removeClass('field-validation-valid').text(errorMessage);
        } else {
            errorElement.addClass('field-validation-valid').removeClass('field-validation-error').text('');
        }
        return isValid;
    }

    function validateSubReasons(subReasonMultiSelect) {
        var errorMessage = 'Please select at least one sub reason.';
        var errorElement = $('span[data-valmsg-for="' + subReasonMultiSelect.attr('name') + '"');
        var $subReasons = subReasonMultiSelect.closest('.coaching-subreasons');
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

