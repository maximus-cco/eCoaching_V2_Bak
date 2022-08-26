$(function () {
    // initialize date picker
    //$(".datepicker").datepicker({ format: 'dd/mm/yyyy', autoclose: true, todayBtn: 'linked' })

    $('body').on('click', '#checkall', function () {
        var status = $("#checkall").prop('checked');
        toggleCheckboxes(status);
        hideShowInativateLink();
    });

    $('body').on('click', '.checkbox-select-employeeLog', function () {
        // Uncheck checkall box
        $('#checkall').prop('checked', false);

        var rowsChecked = $('.checkbox-select-employeeLog:checked').length;
        $('#total-selected').text(rowsChecked + " selected");

        hideShowInativateLink();
    });

    $("#logType").on("change", function () {
        // Hide search result
        $("#search-result").slideUp(500);
        $('#lk-inactivate').slideUp(500);

        var logTypeSelected = $("#logType").val();

        if (logTypeSelected == -1) {
            initPage();
            return false;
        }

        // Remove error msg
        $('#logType').removeClass("input-validation-error");
        $('#type-error-msg').html('');

        // Make ajax call to get modules for the selected type
        $("#module").empty().append('<option value="">Loading...</option>');
        $("#module").addClass('loadinggif');

        $.ajax({
            type: 'POST',
            // Call GetModules method.
            url: getModuleUrl,
            dataType: 'json',
            // Get the value of the selected type (coaching or warning) and pass to GetModulesInJson method.
            data: { logTypeId: logTypeSelected },

            success: function (modules) {
                $("#module").empty();

                // Load Module drowdown
                var options = [];
                $.each(modules, function (i, module) {
                    options.push('<option value="', module.Value, '">' + module.Text + '</option>');
                });

                $("#module").html(options.join(''));
                $("#module").removeClass('loadinggif');
            }
        });

        return false;
    })

    $("#module").on("change", function () {
        // Hide search result
        $("#search-result").slideUp(500);
        $('#lk-inactivate').slideUp(500);

        var logTypeSelected = $("#logType").val();
        var mouduleSelected = $("#module").val();
        //var action = "@Constants.LOG_ACTION_INACTIVATE";

        // if neither Module nor Type is selected
        if (logTypeSelected == -1 || mouduleSelected == -1) {
            resetEmployeeDropdown();
            return false;
        }

        // Remove error msg
        $('#module').removeClass("input-validation-error");
        $('#module-error-msg').html('');

        $("#employee").empty().append('<option value="">Loading...</option>');
        $("#employee").addClass('loadinggif');

        $.ajax({
            type: 'POST',
            // Call GetEmployees method.
            url: getEmployeeUrl,
            dataType: 'json',
            // Get the value of the selected type (coaching or warning), module (csr, training...) and pass to GetEmployees method.
            data: { logTypeId: logTypeSelected, moduleId: mouduleSelected, action: action },

            success: function (employees) {
                $("#employee").empty();

                // Load Employee drowdown
                var options = [];
                $.each(employees, function (i, employee) {
                    options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
                });

                $("#employee").html(options.join(''));
                $("#employee").removeClass('loadinggif');
            }
        });
        return false;
    })

    $("#employee").on("change", function () {
        if ($("#employee").val() != -1) {
            // Remove error msg
            $('#employee').removeClass("input-validation-error");
            $('#employee-error-msg').html('');
        }

        $("#search-result").slideUp(500);
        $('#lk-inactivate').slideUp(500);
    })

    $('body').on('change', '#radio-search-option-default', function () {
        var selected = $(this).is(':checked');
        if (selected === true) {
            $('#div-search-by-default').removeClass('hidden');
            $('#div-search-by-logname').addClass('hidden');
        } else {
            $('#div-search-by-default').addClass('hidden');
            $('#div-search-by-logname').removeClass('hidden');
        }

        $("#search-result").slideUp(500);
        $('#lk-inactivate').slideUp(500);
    })

    $('body').on('change', '#radio-search-option-logname', function () {
        var selected = $(this).is(':checked');
        if (selected === true) {
            $('#div-search-by-logname').removeClass('hidden');
            $('#div-search-by-default').addClass('hidden');
        } else {
            $('#div-search-by-logname').addClass('hidden');
            $('#div-search-by-default').removeClass('hidden');
        }

        $("#search-result").slideUp(500);
        $('#lk-inactivate').slideUp(500);
    })

    $("#logTypeSearchByLogName").on("change", function () {
        if ($(this).val() !== -1) {
            $("#logTypeSearchByLogName").removeClass("input-validation-error");
        }
    })

    $("#input-logname").on("change", function () {
        if ($(this).val() !== '') {
            $("#input-logname").removeClass("input-validation-error");
        }
    })

});

function initPage() {
    // Hide the message
    $(".alert").slideUp(1000);
    // Hide "Inactivate" link.
    $('#lk-inactivate').slideUp(1000);
    // Hide search result.
    $("#search-result").slideUp(1000);
    // Reset Type dropdown.
    $('#logType').val(-1);
    // Reset Employee dropdown.
    // Remove all in Employee dropdown except for the first default item "Please select an employee"
    //$('#employee').find('option:gt(0)').remove();
    resetEmployeeDropdown();

    // Reset Module dropdown.
	// Remove all in Module dropdown except for the first default item "Please select Employee Level"
    resetModuleDropdown();
}

function validateForm() {
    var isFormValid = true;

    var searchByDefault = $('#radio-search-option-default').is(':checked');
    if (searchByDefault === true) {
        if ($('#logType').val() == -1) {
            $('#logType').addClass("input-validation-error");
            //$('#type-error-msg').html('Please select a type');
            isFormValid = false;
        }
        if ($('#module').val() == -1) {
            $('#module').addClass("input-validation-error");
            //$('#module-error-msg').html('Please select Employee Level');
            isFormValid = false;
        }
        if ($('#employee').val() == -1) {
            $('#employee').addClass("input-validation-error");
            //$('#employee-error-msg').html('Please select an employee');
            isFormValid = false;
        }

        return isFormValid;
    }

    // search by log name
    if ($('#logTypeSearchByLogName').val() == -1) {
        $('#logTypeSearchByLogName').addClass("input-validation-error");
        //$('#type-error-msg').html('Please select a type');
        isFormValid = false;
    }
    if ($('#input-logname').val() == '') {
        $('#input-logname').addClass("input-validation-error");
        isFormValid = false;
    }
    return isFormValid;
}

function processSearchOnBegin() {
    if (!validateForm()) {
        return false;
    }
    showSpinner();
}

function processSearchOnComplete() {
    hideSpinner();
    $("#search-result").show();
    hideShowInativateLink();
}

function hideShowInativateLink() {
    var numberChecked = $('.checkbox-select-employeeLog:checked').length;

    if (numberChecked > 0) {
        $('#lk-inactivate').show();
    }
    else {
        $('#lk-inactivate').hide();
    }
}