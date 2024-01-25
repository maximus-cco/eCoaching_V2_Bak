$(document).ready(function () {
    if ($('#dropdown-user-role').val() === "DIR" || $('#dropdown-user-role').val() === "DIRPM" || $('#dropdown-user-role').val() === "DIRPMA") {
        $('#subdata-access-option').removeClass('hide');

        if ($('#SubcontractorDataAccess').val() === "V") {
            $('#view').prop("checked", true);
        } else if ($('#SubcontractorDataAccess').val() === "SV") {
            $('#submissionandview').prop("checked", true);
        }
    }

    $('#dropdown-user-role').on('change', function () {
        if ($(this).val() === "DIR") {
            $('#subdata-access-option').removeClass('hide');
        } else {
            $('#subdata-access-option').addClass('hide');
        }
    });
});