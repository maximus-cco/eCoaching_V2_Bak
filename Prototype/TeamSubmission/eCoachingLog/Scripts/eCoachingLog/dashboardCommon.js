$(function () {
    // Display Review Modal
    $('body').on('click', '.modal-link', function (e) {
        //http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;
            //console.log("!!!Get Detail!!!");
            $(".please-wait").slideDown(500);
            $.ajax({
                type: 'POST',
                url: getLogDetailsUrl,
                dataType: 'html',
                data: { logId: $(this).data("log-id"), isCoaching: $(this).data("is-coaching") },
                success: function (data) {
                    $('#modal-container .modal-content').html(data);
                    $('#modal-container').modal();
                    $('#modal-container').modal('handleUpdate');
                },
                complete: function () {
                    $(".please-wait").slideUp(500);
                }
            });
        }
    });

    // Modal overlay
    $('body').on('click', '.modal-link-overlay', function (e) {
        //http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
        e.preventDefault();
        if (e.handled !== true) {
            e.handled = true;
            //console.log("!!!Get Detail!!!");
            $(".please-wait").slideDown(500);
            $.ajax({
                type: 'POST',
                url: getLogDetailsUrl,
                dataType: 'html',
                data: { logId: $(this).data("log-id"), isCoaching: $(this).data("is-coaching"), action: $(this).data("action") },
                success: function (data) {
                    $('#modal-container-overlay .modal-content').html(data);
                    $('#modal-container-overlay').modal();
                    $('#modal-container-overlay').modal('handleUpdate');
                },
                complete: function () {
                    $(".please-wait").slideUp(500);
                }
            });
        }
    });

    // Quality Now - Display Edit Log Summary Modal
    $('body').on('click', '.modal-link-qn', function (e) {
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;
            $(".please-wait").slideDown(500);
            $.ajax({
                type: 'POST',
                // Call GetLogDetail method.
                url: getLogDetailsUrl,
                dataType: 'html',
                data: {
                    logId: $(this).data("log-id"),
                    isCoaching: $(this).data("is-coaching"),
                    action: $(this).data("action")
                },
                success: function (data) {
                    $('#modal-container .modal-content').html(data);
                    $('#modal-container').modal();
                    $('#modal-container').modal('handleUpdate');
                },
                complete: function () {
                    $(".please-wait").slideUp(500);
                }
            });
        }
    })

    // Search log
    $('body').on('click', '#btn-search', function (e) {
        e.preventDefault();
        if (e.handled !== true) {
            e.handled = true;
            $(".please-wait").slideDown(500);
            var pageSizeSelected = {
                pageSizeSelected: $('input[name=pageSizeSelected').val()
            };

            $.ajax({
                type: 'POST',
                url: searchUrl,
                data: $('#form-search-mydashboard').serialize() + '&' + $.param(pageSizeSelected),
                success: function (data) {
                    // hide please-wait inside DataTables initComplete callback.
                    // Warning logs not allowed to export
                    if ($('input[name=typeSelected').val() === 'MySiteWarning') {
                        $('#btn-export-excel-director').hide();
                    }
                    else {
                        $('#btn-export-excel-director').show();
                    }
                    $('#div-search-result').html(data);
                }
            });
        }
    });

});

