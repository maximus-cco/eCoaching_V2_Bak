var myOptions = {
	layout: {
		padding: {
			bottom: 10
		}
	},
	tooltipCaretSize: 0,
	responsive: true,
	maintainAspectRatio: false,
	title: {
		display: true,
		text: 'Log Distribution By Site'
	},
	legend: {
		display: true,
		position: 'bottom',
		onClick: function (e, p) {
			//console.log(p);
			// ???
		}
	},
	tooltips: {
		mode: 'index', // default to 'index'
		intersect: true,
	},
	hover: {
		mode: 'nearest',
		intersect: true
	},
	tickes: {
		min: 0
	},
	scales: {
		xAxes: [{
			display: true,
			barThickness: 50
			//scaleLabel: {
			//	display: true,
			//	labelString: 'Hour (Denver Time)'
			//}
		}],
		yAxes: [{
			display: true,
			ticks: {
				beginAtZero: true
			},
			scaleLabel: {
				display: true,
				labelString: 'Total Logs'
			}
		}]
	}
};

$(document).ready(function () {
	var ctx = $("#myBar");
	//var ctxBySite = $("#chartBySite");//.getContext('2d');

	$('.chart-container').attr('height', '50vh');

	$.ajax({
		type: "POST",
		url: getChartData,
		dataType: "json",
		success: function (result) {
			//alert(result.data);
			//alert(result.chartTitle);
			var chart = new Chart(ctx,
				{
					type: 'bar',
					data: result.data,
					options: myOptions
				});

			chart.options.title.text = result.chartTitle;

			chart.options.tooltips.mode = 'nearest'; // csr

			chart.update();

			//var chartSite = new Chart(ctxBySite,
			//	{
			//		type: 'line',
			//		data: result.dataSite,
			//		options: lineOptions
			//	});
		},
		error: function (result) {
			alert('error');
		}
	});
	
	var valueNow = 10;
	var divText = valueNow + '%';// + '% Completed';
	$('.progress-bar').css('width', valueNow + '%').attr('varia-valuenow', valueNow);
	$('.progress-bar').text(divText);
});