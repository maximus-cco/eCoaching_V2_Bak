$(document).ready(function () {
    var warning = Morris.Bar({
            element: 'active-warning-bar-chart',
            data: [], // model.GraphViewModel.WarningActive
            xkey: 'x',
            ykeys: ['a', 'b', 'c'],
            labels: ['Final Written Warning', 'Verbal Warning', 'Written Warning'],
            xLabelAngle: 10,
            hideHover: 'auto',
            barColors: ['#FF0000', '#ff9900', '#800000'],
            yLabelFormat: function(y){return y != Math.round(y)?'':y;}
    });

    var pending = Morris.Bar({
            element: 'pending-bar-chart',
            data: [], // model.GraphViewModel.CoachingPending
            xkey: 'x',
            ykeys: ['a', 'b', 'c', 'd', 'e'],
            labels: ['Pending Acknowledgement', 'Pending Employee Review', 'Pending Manager Review', 'Pending Sr. Manager Review', 'Pending Supervisor Review'],
            //xLabelAngle: 10,
            hideHover: 'auto',
            yLabelFormat: function(y){return y != Math.round(y)?'':y;}
    });

    var completed = Morris.Bar({
            element: 'completed-bar-chart',
            data: [], //model.GraphViewModel.CoachingCompleted
            xkey: 'x',
            ykeys: ['a', 'b', 'c', 'd'],
            labels: ['Did not meet goal', 'Met goal', 'Opportunity', 'Reinforcement'],
            xLabelAngle: 10,
            //resize: true, // Significant performance impact, disabled by default.
            hideHover: 'auto',
            barColors: ['#b36b00', '#00b33c', '#0099ff', '#0033cc'],
            yLabelFormat: function(y){return y != Math.round(y)?'':y;},

            //gridIntegers: true,
            //ymin: 0
    });

    warning.setData(model.GraphViewModel.WarningActive);
    pending.setData(model.GraphViewModel.CoachingPending);
    completed.setData(model.GraphViewModel.CoachingCompleted);
})