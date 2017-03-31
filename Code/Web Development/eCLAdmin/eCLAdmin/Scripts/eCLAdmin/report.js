$(function () {
    showSpinner();

    $('#frmReport').on('load', function () {
        hideSpinner();
    });
})