$(function () {
    //alert('partial ready');

    // initialze data picker
    var bindDatePicker = function () {
        $(".date").datetimepicker({
            format: 'YYYY-MM-DD',
            maxDate: 'now'
        }).find('input:first').on("blur", function () {
            var date = parseDate($(this).val());

            if (!isValidDate(date)) {
                // Create date based on momentjs
                date = moment().format('YYYY-MM-DD');
            }

            $(this).val(date);
        });
    }; // bindDatePicker

    var isValidDate = function (value, format) {
        format = format || false;
        if (format) {
            value = parseDate(value);
        }

        var timestamp = Date.parse(value);

        return isNaN(timestamp) == false;
    }; // isValidDate

    var parseDate = function (value) {
        var m = value.match(/^(\d{1,2})(\/|-)?(\d{1,2})(\/|-)?(\d{4})$/);
        if (m) {
            value = m[5] + '-' + ("00" + m[3]).slice(-2) + '-' + ("00" + m[1]).slice(-2)
        }

        return value;
    }; // parseDate

    bindDatePicker();
})