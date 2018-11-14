$(document).ready(function () {
    $('body').on('click', '.view-log-detail', function () {
        $('#modal-container').css('margin-top', '0%');
        $('.modal-content').css('width', '60%');
    });

    $('body').on('click', '.delete-log', function () {
        $('#modal-container').css('margin-top', '5%');
        $('.modal-content').css('width', '35%');
    });
})

function processSearchOnBegin() {
    // Clean up previous delete message
    $('.alert').hide();

    showSpinner();
}

function processSearchOnComplete() {
    hideSpinner();
}