$(document).ready(function () {
    //$('body').on('click', '#view-pending-log-list', function () {
    $('#view-pending-log-list').on('click', function (e) {
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;

            showSpinner();

            $.ajax({
                type: 'POST',
                url: getPendingUrl,

                success: function (data) {
                    hideSpinner();
                    $('#middle').html(data);
                },
                error: function (ex) {
                    hideSpinner();
                    alert('Failed to get pending logs' + ex);
                }
            });
        }
    });

    //$('body').on('click', '#view-completed-list', function (e) {
    $('#view-completed-list').on('click', function (e) {
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;

            $.ajax({
                type: 'POST',
                url: getCompletedUrl,

                success: function (data) {
                    $('#middle').html(data);
                },
                error: function (ex) {
                    alert('Failed to get completed logs' + ex);
                }
            });
        }
    });

    //$('body').on('click', '#view-active-list', function (e) {
    $('#view-active-list').on('click', function (e) {
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;

            $.ajax({
                type: 'POST',
                url: getActiveUrl,

                success: function (data) {
                    $('#middle').html(data);
                },
                error: function (ex) {
                    alert('Failed to get active logs' + ex);
                }
            });
        }
    });
});
