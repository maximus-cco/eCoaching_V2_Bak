﻿/**
 * Show a small bar on the chart if the value is 0.
 */
Chart.plugins.register({
	beforeRender: function (chartInstance) {
		var datasets = chartInstance.config.data.datasets;

		for (var i = 0; i < datasets.length; i++) {
			var meta = datasets[i]._meta;
			// It counts up every time you change something on the chart so
			// this is a way to get the info on whichever index it's at
			var metaData = meta[Object.keys(meta)[0]];
			var bars = metaData.data;

			for (var j = 0; j < bars.length; j++) {
				var model = bars[j]._model;

				if (metaData.type === "horizontalBar" && model.base === model.x) {
					model.x = model.base + 2;
				} else if (model.base === model.y) {
					model.y = model.base - 2;
				}
			}
		}
	}
});

/**
 * Show no data message when no datasets
 */
Chart.plugins.register({
	afterDraw: function (chart) {
		if (chart.data.datasets.length === 0) {
			// No data is present
			var ctx = chart.chart.ctx;
			var width = chart.chart.width;
			var height = chart.chart.height
			chart.clear();

			ctx.save();
			ctx.textAlign = 'center';
			ctx.textBaseline = 'middle';
			//ctx.font = "16px normal 'Helvetica Nueue'";
			ctx.fillText('No data to display.', width / 2, height / 2);
			ctx.restore();
		}
	}
});

var myOptionsByStatus = {
	layout: {
		padding: {
			bottom: 10
		}
	},
	tooltipCaretSize: 0,
	responsive: true,
	maintainAspectRatio: false,
	title: {
		display: true
		//text: 'Log Distribution By Site'
	},
	legend: {
		display: true,
		position: 'bottom'
	},
	tooltips: {
		mode: 'nearest', // default to 'index'
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
		}],
		yAxes: [{
			display: true,
			ticks: {
				beginAtZero: true,
				callback: function(value) { if (value % 1 === 0) {return value; }}
			},
			scaleLabel: {
				display: true,
				labelString: 'Total Logs'
			}
		}]
	}
};

var myOptionsBySite = {
	layout: {
		padding: {
			bottom: 10
		}
	},
	tooltipCaretSize: 0,
	responsive: true,
	maintainAspectRatio: false,
	title: {
		display: true
		//text: 'Log Distribution By Site'
	},
	legend: {
		display: true,
		position: 'bottom'
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
			display: true
		}],
		yAxes: [{
			display: true,
			ticks: {
				beginAtZero: true,
				callback: function (value) { if (value % 1 === 0) { return value; } }
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
	var myOptions = myOptionsByStatus;
	if (isChartBySite === 'True')
	{
		myOptions = myOptionsBySite;
	}

	$.ajax({
		type: "POST",
		url: getChartData,
		data: { monthYear: $('#ddl-month').val() },
		dataType: "json",
		success: function (result) {
			var chart = new Chart(ctx,
				{
					type: 'bar',
					data: result.data,
					options: myOptions
				});
			chart.update();
		},
		error: function (result) {
			$('#modal-container .modal-content').html(
				'<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button>Chart</div>' +
				'<div class="modal-body"><p>Something went wrong while trying to generating bar chart. Please try again at a later time.</p></div>' +
				'<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');
			$('#modal-container').modal();
		}
	});
});