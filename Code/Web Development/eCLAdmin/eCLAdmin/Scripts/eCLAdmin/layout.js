$(function () {
    // http://www.codeproject.com/Tips/826002/Bootstrap-Modal-Dialog-Loading-Content-from-MVC-Pa
    // Initalize modal dialog
    // attach modal-container bootstrap attributes to links with .modal-link class.
    // when a link is clicked with these attributes, bootstrap will display the href content in a modal dialog.
    $('body').on('click', '.modal-link', function (e) {
        e.preventDefault();
        $(this).attr('data-target', '#modal-container');
        $(this).attr('data-toggle', 'modal');
    });

    // Attach listener to .modal-close-btn's so that when the button is pressed the modal dialog disappears
    $('body').on('click', '.modal-close-btn', function () {
        $('#modal-container').modal('hide');
    });

    //clear modal cache, so that new content can be loaded
    $('#modal-container').on('hidden.bs.modal', function () {
        $(this).removeData('bs.modal');
    });

    //$('#CancelModal').on('click', function () {
    $('body').on('click', '#CancelModal', function () {
        return false;
    });

    $.ajaxSetup(
      {
          // Global ajax error function
          error: function (xhr, status, errorMsg) {
              hideSpinner();
              if (xhr.status === 403) {
                  window.location = "Home/SessionExpire";
              }
              else {
                  alert("An error has occurred during ajax call.");
              }
          }
      });
});

function showSpinner() {
    $(".please-wait").slideDown(500);
}

function hideSpinner() {
    $(".please-wait").slideUp(500);
}

function resetEmployeeDropdown() {
    $('#employee').find('option:gt(0)').remove()
}

function resetModuleDropdown() {
    $('#module').find('option:gt(0)').remove()
}

function resetReviewerDropdown() {
    $('#reviewer-dropdown').find('option:gt(0)').remove()
}

function handleAjaxError(xhr, status, error)
{
    if (xhr.status === 403) {
        window.location = "Home/SessionExpire";
    }
    else {
        window.location = "Error/Index";
    }
}
