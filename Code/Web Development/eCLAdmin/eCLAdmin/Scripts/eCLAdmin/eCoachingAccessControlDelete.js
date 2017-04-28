$(document).ready(function () {
    $('#modal-container').css('margin-top', '10%');
    $('.modal-content').css('width', '30%');

    // Prevent form multiple submits
    $('body').on('click', '#btn-delete', function () {
        $(this).attr('disabled', 'disabled');
    });

    $('#btn-delete').on('click', function (event) {
        event.preventDefault();

        $('#modal-container').modal('hide');

        var ajaxRequest = $.ajax({
            url: deleteUserUrl,
            type: 'POST',
            data: $('#form-delete-ecoaching-access-control').serialize(),
            dataType: "json"
        });

        ajaxRequest.done(function (msg) {
            if (msg.success == true) {
                userTable.row(rowSelected.parents('tr')).remove().draw(false);
                var info = 'The user has been successfully deleted.';
                $("#message").html('<div class="alert alert-success"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + info + '</div>');
                $("#message").slideDown();
            } else {
                var info = 'Failed to delete the user.';
                $("#message").html('<div class="alert alert-warning"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + info + '</div>');
                $("#message").slideDown();
            };

            window.setTimeout(function () {
                if (msg.success == true) {
                    $("#message").slideUp();
                }
            }, 2000);
        });

        ajaxRequest.fail(function (jqXHR, textStatus) {
            var info = 'Failed to delete the user.';
            $("#message").html('<div class="alert alert-danger"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + info + '</div>');
        });
    }) // end of $('#btn-delete').on('click', function ()

})