function showNotification(message, icon, type) {
    //function displayMessage(message, icon, type) {
    $.notify({
        message: message,
        icon: icon,
    },
    {
        type: type,
        delay: 10000, // 10 seconds
        placement: {
            from: "bottom",
            align: "right"
        },
        offset: {
            x: 30,
            y: 10
        },
        animate: {
            enter: 'animated fadeInUp',
            exit: 'animated fadeOutDown'
        },
        mouse_over: 'pause',
    }); // end notify
}