$(function () {
    var previousDate = null; 
    $('#div-hire-date').datetimepicker({
        allowInputToggle: true,
        // defaultDate: new Date(),
        format: 'MM/DD/YYYY',
        maxDate: 'now'
    }).on('dp.change', function (e) { handleHireDateChange() });

    function handleHireDateChange() {
        // db.change fires 2 times initially
        // only reload employee when a different hire date is selected
        let currentDate = $('#HireDate').val();
        if (previousDate && previousDate === currentDate) {
            return;
        } else {
            previousDate = currentDate;
            loadEmployees();
        }
    }

    $("#select-site").on("change", function () {
        loadEmployees();
    });

    $("#select-level").on("change", function () {
        resetEmployees();
        loadSites();
        loadReasons();
        loadLogStatus();
    });

    $("#select-reason").on("change", function () {
        loadSubreasons();
    });

    $('#btn-generate-report').on('click', function (e) {
        e.preventDefault();

        if (!validate()) {
            return;
        }

        if (e.handled !== true) {
            e.handled = true;
            $('.please-wait').slideDown(500);
            $.ajax({
                type: 'POST',
                url: generateReportUrl,
                data: $('form').serialize(),
                success: function (data) {
                    $('.required').css('border-color', '');
                    resetReportDiv();
                    if (data.valid === false) {
                        $.each(data.validationErrors, function (key, value) {
                            $('[name="' + key + '"').css('border-color', 'red');
                        });
                    } else {
                        $('#div-report').html(data);
                    }
                }
            }).always(function () {
                $('.please-wait').slideUp(500);
            });
        } // end if e.handled
    });

    $('#btn-export-excel').on('click', function (e) {
        e.preventDefault();
        $(this).prop('disabled', true);

        if (e.handled !== true) {
            e.handled = true;
            $('.please-wait').slideDown(500);
            $.ajax({
                type: 'POST',
                url: exportToExcelUrl,
                data: $('form').serialize(),
                success: function (data) {
                    // clean up
                    $('#btn-export-excel').prop('disabled', false);
                    $(".please-wait").slideUp(500);

                    if (data.result === 'success') {
                        window.location = downloadExcelUrl;
                    } else {
                        $('#modal-container .modal-content').html(
							'<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">Export to Excel</h4></div>' +
							'<div class="modal-body"><p>Something went wrong. Please try again later.</p></div>' +
							'<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');
                        $('#modal-container').modal();
                    }
                }
            }); // $.ajax
        }
    }); // end Export to excel

    $('.required').on('change', function (e) {
        if ($(this).val() != -2) {
            $(this).css('border-color', '');
        } else {
            $(this).css('border-color', 'red');
        }
    });

    function validate() {
        let valid = true;
        $('.required').each(function () {
            if ($(this).val() == undefined || $(this).val() == -2 || $(this).val() == '' || $(this).val() == 'Select Action') {
                $(this).css('border-color', 'red');
                valid = false;
            } else {
                $(this).css('border-color', '');
            }
        });

        return valid;
    }
    
    function resetEmployees() {
        $('#select-employee').empty();
        $('#select-employee').html('<option value="-2">Select Employee</option>');
    }

    function resetReportDiv() {
        // hide search inputs
        $('#div-report-header').removeClass('show');
        $('#div-report-header').addClass('hide');
        // hide export to excel link
        $('#div-export-to-excel').removeClass('show');
        $('#div-export-to-excel').addClass('hide');
        // clean up report
        $('#div-report').html('');
    }

    function loadLogStatus() {
        let moduleSelected = $('#select-level').val();
        if (moduleSelected == -2) {
            $('#select-logstatus').find('option').not(':first').remove();
            return;
        }

        $('#select-logstatus').addClass('loadinggif')
        $.ajax({
            type: 'POST',
            url: getLogStatusListUrl,
            dataType: 'json',
            data: { moduleId: moduleSelected, isWarning: $('#isWarning').val() },

            success: function (statuslist) {
                $('#select-status').empty();
                var options = [];
                $.each(statuslist, function (i, status) {
                    options.push('<option value="', status.Value, '">' + status.Text + '</option>');
                });

                $('#select-logstatus').html(options.join(''));
                $('#select-logstatus').removeClass('loadinggif');
            }
        });
        return false;
    }

    function loadReasons() {
        let moduleSelected = $('#select-level').val();
        if (moduleSelected == -2) {
            $('#select-reason').find('option').not(':first').remove();
            return;
        }

        $('#select-reason').addClass('loadinggif')
        $.ajax({
            type: 'POST',
            url: getReasonsUrl,
            dataType: 'json',
            data: { moduleId: moduleSelected, isWarning: $('#isWarning').val() },

            success: function (reasons) {
                $('#select-reason').empty();
                var options = [];
                $.each(reasons, function (i, reason) {
                    options.push('<option value="', reason.Value, '">' + reason.Text + '</option>');
                });

                $('#select-reason').html(options.join(''));
                $('#select-reason').removeClass('loadinggif');
            }
        });
        return false;
    }

    function loadSubreasons() {
        let reasonSelected = $('#select-reason').val();
        if (reasonSelected == -2) {
            $('#select-subreason').find('option').not(':first').remove();
            return;
        }

        $('#select-subreason').addClass('loadinggif')
        $.ajax({
            type: 'POST',
            url: getSubreasonsUrl,
            dataType: 'json',
            data: { reasonId: reasonSelected, isWarning: $('#isWarning').val() },

            success: function (subreasons) {
                $('#select-subreason').empty();
                var options = [];
                $.each(subreasons, function (i, subreason) {
                    options.push('<option value="', subreason.Value, '">' + subreason.Text + '</option>');
                });

                $('#select-subreason').html(options.join(''));
                $('#select-subreason').removeClass('loadinggif');
            }
        });
        return false;
    }

    function loadEmployees() {
        let siteSelected = $('#select-site').val();
        let moduleSelected = $('#select-level').val();
        if (siteSelected == -2 || moduleSelected == -2) {
            $('#select-employee').find('option').not(':first').remove();
            return;
        }

        $('#select-employee').addClass('loadinggif')
        $.ajax({
            type: 'POST',
            url: getEmployeesUrl,
            dataType: 'json',
            data: { moduleId: moduleSelected, siteId: siteSelected, hireDate: $('#HireDate').val(), isWarning: $('#isWarning').val() },

            success: function (employees) {
                $('#select-employee').empty();
                var options = [];
                $.each(employees, function (i, employee) {
                    options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
                });

                $('#select-employee').html(options.join(''));
                $('#select-employee').removeClass('loadinggif');
            }
        });
        return false;
    }

    function loadSites() {
        let moduleSelected = $('#select-level').val();
        if (moduleSelected == -2) {
            $('#select-site').find('option').not(':first').remove();
            return;
        }

        $('#select-site').addClass('loadinggif')
        $.ajax({
            type: 'POST',
            url: getSitesUrl,
            dataType: 'json',
            data: { moduleId: moduleSelected },

            success: function (sites) {
                $('#select-site').empty();
                var options = [];
                $.each(sites, function (i, site) {
                    options.push('<option value="', site.Value, '">' + site.Text + '</option>');
                });

                $('#select-site').html(options.join(''));
                $('#select-site').removeClass('loadinggif');
            }
        });

        return false;
    }

});