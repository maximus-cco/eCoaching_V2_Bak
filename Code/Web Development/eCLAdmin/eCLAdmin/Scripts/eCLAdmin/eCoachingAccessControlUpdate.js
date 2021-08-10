$(document).ready(function () {
    $('#modal-container').css('margin-top', '10%');
    $('.modal-content').css('width', '35%');

    $('#btn-update').on('click', function (e) {
        // Prevent form multiple submits
        $(this).attr('disabled', 'disabled');
        event.preventDefault();

        var form = $('#form-edit-ecoaching-access-control');
        $.validator.unobtrusive.parse(form);
        if (!form.valid()) {
            return false;
        }

        var ajaxRequest = $.ajax({
            url: updateUserUrl,
            type: 'POST',
            data: $('#form-edit-ecoaching-access-control').serialize(),
            dataType: "json"
        });

        ajaxRequest.done(function (data) {
            var result = data.result;
            if (result === "success") {
                $('#modal-container').modal('hide');

                // Update the row with data returned from controller
                var rowUpdated = userTable.row(rowSelected.parents('tr')).data(data.user).draw(false).node();
                $(rowUpdated).css("color", "orange");

                var info = 'The user has been successfully updated.';
                $("#message").html('<div class="alert alert-success"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + info + '</div>');
                $("#message").slideDown();
            } else if (result === "fail") {
                var info = 'Failed to update the user.';
                $("#message").html('<div class="alert alert-warning"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + info + '</div>');
                $("#message").slideDown();
            } else if (result === "datainvalid") {
                $("#validation-msg").html('<div class="alert alert-warning">Please correct the errors and try again.</div>');
            };

            window.setTimeout(function () {
                if (result === "success") {
                    $("#message").slideUp();
                }
            }, 2000);
        });

        ajaxRequest.fail(function (jqXHR, textStatus) {
            var info = 'Failed to update the user.';
            $("#message").html('<div class="alert alert-danger"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + info + '</div>');
        });
    }) // end $('#btn-update').on('click', function (e) 

})