$(document).ready(function () {
    // Set modal location and size
    $('#modal-container').css('margin-top', '10%');
    $('.modal-content').css('width', '35%');

    // Initialize dropdown select2
    //$('#dropdown-user-name').select2();
    //$('#dropdown-user-site').select2();
    //$('#dropdown-user-role').select2();

    // Load potential users from the site selected
    $('body').on('change', '#dropdown-user-site', function () {
        var siteId = $("#dropdown-user-site option:selected").val();

        // Display "Loading..." with ajax loader gif
        $("#dropdown-user-name").empty().append('<option value="">Loading...</option>');
        $("#div-loading").addClass('loadinggif');

        $.ajax({
            type: 'POST',
            url: loadUsersBySiteUrl,
            data: { siteId: siteId },
            datatType: "json",
            success: function (nameLanIds) {
                $("#dropdown-user-name").empty();

                // Bind to dropdown
                var options = [];
                $.each(nameLanIds, function (i, nameLanIds) {
                    options.push('<option value="', nameLanIds.Value, '">' + nameLanIds.Text + '</option>');
            });

            $("#dropdown-user-name").html(options.join(''));
            $("#div-loading").removeClass('loadinggif');
        }
        });


    });

    var form = $('#form-add-ecoaching-access-control');
    // Submit the form
    form.on('submit', function (event) {
        event.preventDefault();

        $.validator.unobtrusive.parse(form);
        if (!form.valid()) {
            return false;
        }

        // Disable Add button to prevent multiple submits
        $(this).attr('disabled', 'disabled');

        // Set the name selected to view model
        var nameSelected = $("#dropdown-user-name option:selected").text();
        $("#Name").val(nameSelected);

        var ajaxRequest = $.ajax({
            url: addUserUrl,
            type: 'POST',
            data: $('#form-add-ecoaching-access-control').serialize(),
            dataType: "json"
        });

        ajaxRequest.done(function (data) {
            var result = data.result;
            var message = data.msg;
            if (result === "success") {
                $('#modal-container').modal('hide');

                // Add a row with data returned from controller
                var rowAdded = userTable.row.add(data.user).draw(false).node();
                $(rowAdded).css("color", "red");

                $("#message").html('<div class="alert alert-success"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + message + '</div>');
                $("#message").slideDown();
            } else if (result === "fail") {
                $('#modal-container').modal('hide');

                $("#message").html('<div class="alert alert-warning"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + message + '</div>');
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
            var info = 'Failed to add the user.';
            $("#message").html('<div class="alert alert-danger"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + info + '</div>');
        });

    }) // end of form.on('submit', function (event)
})
