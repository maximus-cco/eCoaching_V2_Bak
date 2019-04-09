$(function () {
	$('#div-body').removeClass('container');
	showSpinner();
    $('#frmReport').on('load', function () {
        hideSpinner();
    });
})