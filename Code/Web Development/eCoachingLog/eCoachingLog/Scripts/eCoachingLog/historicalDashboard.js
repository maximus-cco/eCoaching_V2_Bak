$(document).ready(function () {
	$('body').on('change', '.employee-status', function () {
		var empStatusSelected = $('input:radio[name="Search.ActiveEmployee"]:checked').val();
		// Inactive: 2; Both: 3
		if (empStatusSelected === '2' || empStatusSelected === '3') {
			$.notify({
				title : '<strong>Caution: </strong>',
				message: 'It takes much longer to load employee dropdown when selecting Inactive or Both.',
				icon: 'glyphicon glyphicon-info-sign',
				},
				{
				type: 'info',
				delay: 3000, // 3 seconds
				timer: 1000,
				placement: {
					from: "top",
					align: "right"
				},
				offset: {
					x: 10,
					y: 100
				},
				animate: {
					enter: 'animated fadeInDown',
					exit: 'animated fadeOutUp'
				},
				mouse_over: 'pause',
			});
		}

		// Reload employees, since a different employee staus radio button is selected
		var supervisorSelected = $('#select-supervisor').val();
		if (supervisorSelected !== '-2') {
			ReloadEmployees();
		}
	});

	$('body').on('change', '#select-site', function () {
		$('#select-manager').addClass('loadinggif');
		var siteSelected = $('#select-site').val();
		if (siteSelected != -2)
		{
			$(this).css('border-color', '');
		}

	    $.ajax({
	        type: 'POST',
	        url: getManagersUrl,
	        dataType: 'json',
	        data: { siteId: siteSelected }
	    })
        .done(function (data) {
              // Reload managers
              var options = [];
              $.each(data.managers, function (i, manager) {
                  options.push('<option value="', manager.Value, '">' + manager.Text + '</option>');
              });
              $("#select-manager").html(options.join(''));
              // Reload supervisors
              options = [];
              $.each(data.supervisors, function (i, supervisor) {
                  options.push('<option value="', supervisor.Value, '">' + supervisor.Text + '</option>');
              });
              $("#select-supervisor").html(options.join(''));
              // Reload employees
              options = [];
              $.each(data.employees, function (i, employee) {
                  options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
              });
              $("#select-employee").html(options.join(''));
        })
		.fail(function () {
		    $('#select-manager').html('<option value="">error ...&nbsp;&nbsp;</option>');
		})
		.always(function () {
		    $('#select-manager').removeClass('loadinggif')
		});
	});

	$('body').on('change', '#select-manager', function () {
		$('#select-supervisor').addClass('loadinggif');
		var mgrSelected = $('#select-manager').val();
		if (mgrSelected != -2) {
			$(this).css('border-color', '');
		}

		$.ajax({
		    type: 'POST',
		    url: getSupervisorsUrl,
		    dataType: 'json',
		    data: { mgrId: mgrSelected }
		})
        .done(function (data) {
            // Load supervisor dropdown
            var options = [];
            $.each(data.supervisors, function (i, supervisor) {
                options.push('<option value="', supervisor.Value, '">' + supervisor.Text + '</option>');
            });
            $("#select-supervisor").html(options.join(''));
            // Load Employee dropdown
            options = [];
            $.each(data.employees, function (i, employee) {
                options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
            });
            $("#select-employee").html(options.join(''));
        })
		.fail(function () {
		    $('#select-supervisor').html('<option value="">error ...&nbsp;&nbsp;</option>');
		})
		.always(function () {
		    $('#select-supervisor').removeClass('loadinggif')
		});
	});

	$('body').on('change', '#select-supervisor', function () {
		if ($(this).val() != -2) {
			$(this).css('border-color', '');
		}
		ReloadEmployees();
	});

	$('body').on('change', '#select-employee', function () {
		if ($(this).val() != -2) {
			$(this).css('border-color', '');
		}
	});

	$('body').on('change', '#select-source', function () {
        // coaching reason list is the same for all sources for non hr users.
	    if ($("#AllowSearchWarning").val() !== "True") {
	        return;
	    }

	    let prev = $("#sourceSelected").val();
        let curr = $(this).val();
        // save in hidden
        $("#sourceSelected").val(curr);

        // hr users - reload coaching reasons if warning or all changed
        if (curr === "120" || prev === "120") { // 120: warning
            loadReasons(curr);
        } else if (curr === "-1" || prev === "-1") { // -1: ALL
            loadReasons(curr);
        }
    });

	function loadReasons(sourceSelected)
	{
	    $('#select-reason').addClass('loadinggif');

	    $.ajax({
	        type: 'POST',
	        url: getReaonsUrl,
	        dataType: 'json',
	        data: { sourceId: sourceSelected }
	    })
	    .done(function (data) {
	        // Reload reasons
	        var options = [];
	        $.each(data.reasons, function (i, reason) {
	            options.push('<option value="', reason.Value, '">' + reason.Text + '</option>');
	        });
	        $("#select-reason").html(options.join(''));
	    })
	    .fail(function () {
	        $('#select-reason').html('<option value="">error ...&nbsp;&nbsp;</option>');
	    })
	    .always(function () {
	        $('#select-reason').removeClass('loadinggif')
	    });
	}

	function ReloadEmployees()
	{
	    $('#select-employee').addClass('loadinggif');

	    $.ajax({
	        type: 'POST',
	        url: getEmployeesUrl,
	        dataType: 'json',
	        data: {
	            siteId: $('#select-site').val(),
	            mgrId: $('#select-manager').val(),
	            supId: $('#select-supervisor').val(),
	            employeeStatus: $('input:radio[name="Search.ActiveEmployee"]:checked').val()
	        }
	    })
        .done(function (employees) {
        	var options = [];
        	$.each(employees, function (i, employee) {
        		options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
        	});
        	$("#select-employee").html(options.join(''));
        })
		.fail(function () {
		    $('#select-employee').html('<option value="">error ...&nbsp;&nbsp;</option>');
		})
		.always(function () {
		    $('#select-employee').removeClass('loadinggif')
		});
	}

	$('body').on('click', '#btn-reset', function (e) {
		e.preventDefault();

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$('#div-search-result').removeClass('show');
			$('#div-search-result').addClass('hide');
			$.ajax({
				url: resetPageUrl,
				success: function (data) {
					$('#div-search').html(data);
				},
				complete: function () {
					$(".please-wait").slideUp(500);
				}
			}) // end ajax
		} // end if
	});

	$('body').on('change', '.reset-search-result', function () {
		$('#div-search-result').removeClass('show');
		$('#div-search-result').addClass('hide');
	});

	$('body').on('click', '#btn-search-historical', function (e) {
		e.preventDefault();

		if (!validateSearch()) {
			return;
		}

		$("#Search_ReasonText").val($("#select-reason").find("option:selected").text());
		$("#Search_SubReasonText").val($("#select-subreason").find("option:selected").text());

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
					type: 'POST',
					url: searchUrl,
					data: $('#form-search-historical').serialize(),
					success: function (data) {
						$('#div-search-result').removeClass('hide');
						$('#div-search-result').addClass('show');
						$('#div-log-list').html(data);
					},
					complete: function () {
						$(".please-wait").slideUp(500);
					}
			}); // end of $.ajax
		} // end of if (e.handled !== true)
	});

	function validateSearch()
	{
		var valid = true;
		var siteSelected = $('#select-site').val();
		var mgrSelected = $('#select-manager').val();
		var supSelected = $('#select-supervisor').val();
		var empSelected = $('#select-employee').val();

		if (siteSelected == -2)
		{
			$('#select-site').css('border-color', 'red');
			valid = false;
		}
		if (mgrSelected == -2)
		{
			$('#select-manager').css('border-color', 'red');
			valid = false;
		}
		if (supSelected == -2)
		{
			$('#select-supervisor').css('border-color', 'red');
			valid = false;
		}
		if (empSelected == -2)
		{
			$('#select-employee').css('border-color', 'red');
			valid = false;
		}
		if (empSelected == -2) {
		    $('#select-employee').css('border-color', 'red');
		    valid = false;
		}

		return valid;
	}

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

					if (data.result === 'success') {
						window.location = downloadExcelUrl;
					}
					else if (data.result === 'overLimit') {
						$('#modal-container .modal-content').html(
							'<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">Export to Excel</h4></div>' +
							'<div class="modal-body"><p>The maximum number of records that can be exported at a time is 20,000. You are trying to export ' + data.total + ' records. Please refine your filters and try again.</p></div>' +
							'<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');
						$('#modal-container').modal();
					}
						// fail
					else {
						$('#modal-container .modal-content').html(
							'<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">Export to Excel</h4></div>' +
							'<div class="modal-body"><p>Something went wrong while trying to export logs to excel file. Please try again.</p></div>' +
							'<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');
						$('#modal-container').modal();
					}
				}
			});
		}
	});
});