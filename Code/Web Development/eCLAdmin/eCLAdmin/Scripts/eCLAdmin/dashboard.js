$(document).ready(function () {
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
                }
            });
        }
    });

    $('#view-completed-list').on('click', function (e) {
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;

            $.ajax({
                type: 'POST',
                url: getCompletedUrl,

                success: function (data) {
                    $('#middle').html(data);
                }
            });
        }
    });

    $('#view-active-list').on('click', function (e) {
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;

            $.ajax({
                type: 'POST',
                url: getActiveUrl,

                success: function (data) {
                    $('#middle').html(data);
                }
            });
        }
    });
});
