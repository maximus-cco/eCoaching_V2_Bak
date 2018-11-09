$(document).ready(function () {
	var type = 'hour';
	var myChart = Morris.Line({
		element: 'ecl-site-usage-chart',
		data: [],
		xkey: 'TimeSpanXLabel',
		ykeys: [
			'TotalHitsNewSubmission',
			'TotalUsersNewSubmission',
			'TotalHitsMyDashboard',
			'TotalUsersMyDashboard',
			'TotalHitsHistorical',
			'TotalUsersHistorical',
			'TotalHitsReview',
			'TotalUsersReview'
		],
		labels: [
			'TotalHitsNewSubmission',
			'TotalUsersNewSubmission',
			'TotalHitsMyDashboard',
			'TotalUsersMyDashboard',
			'TotalHitsHistorical',
			'TotalUsersHistorical',
			'TotalHitsReview',
			'TotalUsersReview'
		],
		xLabelAngle: 85,
		padding: 60,
		hideHover: 'auto',
		parseTime: false,
		yLabelFormat: function (y) { return y != Math.round(y) ? '' : y; }
	});

	myChart.setData(model.Statistics);
})