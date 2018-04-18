$(document).ready(function () {
	$('#select-site').on("change", function () {
		$('#select-manager').addClass('loadinggif');
		var siteSelected = $('#select-site').val();
		$.getJSON(getManagersUrl, { siteId: siteSelected })
			.done(function (managers) {
				var options = [];
				$.each(managers, function (i, manager) {
					options.push('<option value="', manager.Value, '">' + manager.Text + '</option>');
				});
				$("#select-manager").html(options.join(''));
			})
			.fail(function () {
				$('#select-manager').html('<option value="">Error loading managers ...&nbsp;&nbsp;</option>');
			})
			.complete(function () {
				$('#select-manager').removeClass('loadinggif')
		});
	});

	$('#select-manager').on("change", function () {
		$('#select-supervisor').addClass('loadinggif');
		var mgrSelected = $('#select-manager').val();
		$.getJSON(getSupervisorsUrl, { mgrId: mgrSelected })
			.done(function (supervisors) {
				var options = [];
				$.each(supervisors, function (i, supervisor) {
					options.push('<option value="', supervisor.Value, '">' + supervisor.Text + '</option>');
				});
				$("#select-supervisor").html(options.join(''));
			})
			.fail(function () {
				$('#select-supervisor').html('<option value="">Error loading supervisors ...&nbsp;&nbsp;</option>');
			})
			.complete(function () {
				$('#select-supervisor').removeClass('loadinggif')
			});
	});

	$('#select-supervisor').on("change", function () {
		$('#select-employee').addClass('loadinggif');
		var supSelected = $('#select-supervisor').val();
		$.getJSON(getEmployeesUrl, { supId: supSelected })
			.done(function (employees) {
				var options = [];
				$.each(employees, function (i, employee) {
					options.push('<option value="', employee.Value, '">' + employee.Text + '</option>');
				});
				$("#select-employee").html(options.join(''));
			})
			.fail(function () {
				$('#select-employee').html('<option value="">Error loading employees ...&nbsp;&nbsp;</option>');
			})
			.complete(function () {
				$('#select-employee').removeClass('loadinggif')
			});
	});



	$('#btn-reset').on("click", function () {
		$('#div-search-result').removeClass('show');
		$('#div-search-result').addClass('hide');
		$.ajax({
			url: resetPageUrl,
			success: function (data) {
				$('#div-search').html(data);
			}
		});
	});

	$('body').on('click', '#btn-search-historical', function (e) {
		e.preventDefault();

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
});