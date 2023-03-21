$(document).ready(function () {
    // Show how many pendings on page inital display
    if (typeof showPendingText !== 'undefined' && showPendingText === true) {
        var msg = 'You have <span class="lead">' + totalPending + '</span> pending logs that require your action.';
        showNotification(msg, "glyphicon glyphicon-bell", "info");
    }

    $('body').on('click', '#a-close', function (e) {
        $('#qn-log-list').hide();
    });

	$('body').on('click', '.my-dashboard-log-list', function (e) {
	    e.preventDefault();

		if (e.handled !== true) {
			e.handled = true;
			$(".please-wait").slideDown(500);
			$.ajax({
				type: 'POST',
				url: getLogListUrl,
				data: { whatLog: $(this).data("log") },
				success: function (data) {
					$(".please-wait").slideUp(500);
					$('#div-log-list').html(data);
				}
			});
		}
	});

	$('body').on('click', '.rd-qn-qns', function (e) {
	    if (e.handled !== true) {
	        e.handled = true;
	        $(".please-wait").slideDown(500);

	        $.ajax({
	            type: 'POST',
	            url: filterByQnOrQnsUrl,
	            data: { sourceId: $(this).val(), pageSize: $('input[name=pageSizeSelected').val() },
	            success: function (data) {
	                $('#div-search-result').html(data);
	            }
	        }); // end $.ajax
	    } // end  if (e.handled !== true) 

	});

	$('body').on('click', '#btn-save-summary', function (e) {
	    e.preventDefault();
	    $(this).prop('disabled', true);
	    saveSummary(qnSaveSummaryUrl);
	});

	$('body').on('change keyup paste mouseup', '#summary', function (e) {
        if ($('#summary').val().trim().length > 0)
        {
            $('#summary').removeClass("errorClass");
            $('#validation-summary').addClass("hide");
        }
    })
    
	$('body').on('click', '#btn-submit', function (e) {
	    e.preventDefault();
	    $(this).prop('disabled', true);
	    submitReview(saveUrl, myTable);
	});

	function submitReview(url, tableToRefresh) {
	    // Do not send input fields in hidden div (display:none) to server
	    $('div:hidden :input').prop("disabled", true);

	    var request = $.ajax({
	        type: 'POST',
	        url: url,
	        data: $('#form-mydashboard-review-pending').serialize(),
	        dataType: 'json'
	    });

	    request.always(function (data) {
	        $(".please-wait").slideUp(500); // Hide spinner
	    });

	    request.done(function (data) {
	        if (data.valid === false) {
	            $('#btn-submit').prop('disabled', false);
	            $('#div-error-prompt').html('<br />Please correct the error(s) and try again.');

	            // Reset all error msgs
	            $.each(data.allfields, function (i, field) {
	                $('[name="' + field + '"]').removeClass('errorClass');
	                container = $('span[data-valmsg-for="' + field + '"]').html('');
	            });

	            // Display error msgs
	            $.each(data.errors, function (key, value) {
	                var container = $('span[data-valmsg-for="' + key + '"]');
	                container.removeClass("field-validation-valid").addClass("field-validation-error");
	                container.html(value);

	                $('[name="' + key + '"]').addClass('errorClass');
	            });
	        }
	        else {
	            if (data.success === true) {
	                $('#modal-container').modal('hide');
	                // Refresh log list, server side LoadDataQn gets called
	                tableToRefresh.ajax.reload();
	                //// Update count display
	                //$countToUpdate.html(data.count);
	                showNotification(data.successMsg, "glyphicon glyphicon-saved", "success");
	            }
	            else {
	                $('#modal-container').modal('hide');
	                showNotification(data.errorMsg, "glyphicon glyphicon-warning-sign", "danger");
	            }
	        }
	    });
	}

	function saveSummary(url) {
	    if ($('#summary').val().trim().length == 0)
	    {
	        $('#summary').addClass("errorClass");
	        $('#validation-summary').removeClass("hide");
	        $('#btn-save-summary').prop('disabled', false);
	        return false;
	    }

	    $('#summary').removeClass("errorClass");
	    $('#validation-summary').addClass("hide");


	    var logId = $('#logId').val();
        var request = $.ajax({
	        type: 'POST',
	        url: url,
	        data: { logId: logId, summary: $('#summary').val() },
	        dataType: 'json'
	    });

	    request.always(function (data) {
	        $(".please-wait").slideUp(500); // Hide spinner
	    });

	    request.done(function (data) {
	        if (data.success === true) {
	            $('#modal-container').modal('hide');
	            showNotification(data.successMsg, "glyphicon glyphicon-saved", "success");
	            // Display "Prepare" in grey, "Coach" in green
	            $('#p' + logId).css('color', 'grey');
	            $('#c' + logId).css('color', 'green');
	        } else {
	            $('#modal-container').modal('hide');
	            showNotification(data.errorMsg, "glyphicon glyphicon-warning-sign", "danger");
	        } // end if
	    }); // end request.done
    } // end function saveSummary

})
