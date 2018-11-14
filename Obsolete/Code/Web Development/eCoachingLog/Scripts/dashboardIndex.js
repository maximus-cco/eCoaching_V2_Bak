$(document).ready(function () {
    $("#ddl-month").on("change", function () {
        //var selected = $("#ddl-month").val();
        var selectedText = $("#ddl-month").find("option:selected").text();
        $("#lbl-month").text(selectedText);

        $(this.form).submit();
    });
});
