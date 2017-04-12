// We use an "Immediate Function" to initialize the application to avoid leaving anything behind in the global scope
(function () {


    /* --------------------------------- Event Registration -------------------------------- */
    $('.event-btn').on('click', function() {
        app47.genericEvent("Generic Event Clicked");
        alert("Generic Event Sent");
    });
 
    $('.log-btn').on('click', function() {
        app47.info("Log Button Clicked");
        alert("Info Log Sent");
    });

}());
