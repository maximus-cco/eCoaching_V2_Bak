$(document).ready(function () {
    // Prevent form multiple submits
    $('body').on('click', '#btn-delete', function () {
        $(this).attr('disabled', 'disabled');
    });
})