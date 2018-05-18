$(document).ready(function () {
	$('body').on('change', '.employee-status', function () {
		var empStatusSelected = $('input:radio[name="Search.ActiveEmployee"]:checked').val();
		var supervisorSelected = $('#select-supervisor').val();
		// Reload employees, since a different employee staus radio button is selected
		if (supervisorSelected !== '-2')
		{
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

		$.getJSON(getManagersUrl, { siteId: siteSelected })
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
			.complete(function () {
				$('#select-manager').removeClass('loadinggif')
		});
	});

	$('body').on('change', '#select-manager', function () {
		$('#select-supervisor').addClass('loadinggif');
		var mgrSelected = $('#select-manager').val();
		if (mgrSelected != -2) {
			$(this).css('border-color', '');
		}
		$.getJSON(getSupervisorsUrl, { mgrId: mgrSelected })
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
			.complete(function () {
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

	function ReloadEmployees()
	{
		$('#select-employee').addClass('loadinggif');
		$.getJSON(getEmployeesUrl,
			{
				siteId: $('#select-site').val(),
				mgrId: $('#select-manager').val(),
				supId: $('#select-supervisor').val(),
				employeeStatus: $('input:radio[name="Search.ActiveEmployee"]:checked').val()
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
			.complete(function () {
				$('#select-employee').removeClass('loadinggif')
			});
	}

	$('body').on('click', '#btn-reset', function () {
		$('#div-search-result').removeClass('show');
		$('#div-search-result').addClass('hide');
		$.ajax({
			url: resetPageUrl,
			success: function (data) {
				$('#div-search').html(data);
			}
		});
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

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				url: searchUrl,
				data: $('#form-search-historical').serialize(),
				success: function (data) {
					$(".please-wait").slideUp(500);
					$('#div-search-result').removeClass('hide');
					$('#div-search-result').addClass('show');
					$('#div-log-list').html(data);
				}
			});
		}
	});

	function validateSearch()
	{
		var valid = true;
		//var $summaryUl = $('.validation-summary-valid').find('ul');
		//$summaryUl.empty();
		var siteSelected = $('#select-site').val();
		var mgrSelected = $('#select-manager').val();
		var supSelected = $('#select-supervisor').val();
		var empSelected = $('#select-employee').val();
		if (siteSelected == -2)
		{
			//$summaryUl.append($('<li>').text('Please select a site.'));
			$('#select-site').css('border-color', 'red');
			valid = false;
		}
		if (mgrSelected == -2)
		{
			//$summaryUl.append($('<li>').text('Please select a manager.'));
			$('#select-manager').css('border-color', 'red');
			valid = false;
		}
		if (supSelected == -2)
		{
			//$summaryUl.append($('<li>').text('Please select a supervisor.'));
			$('#select-supervisor').css('border-color', 'red');
			valid = false;
		}
		if (empSelected == -2)
		{
			//$summaryUl.append($('<li>').text('Please select an employee.'));
			$('#select-employee').css('border-color', 'red');
			valid = false;
		}
		//$('.validation-summary-valid').css('display', 'block');
		//$('.validation-summary-valid').css('color', 'red');
		return valid;
	}
});