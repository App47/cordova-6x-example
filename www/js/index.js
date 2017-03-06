// We use an "Immediate Function" to initialize the application to avoid leaving anything behind in the global scope
(function () {


    /* --------------------------------- Event Registration -------------------------------- */
    /* send a generic event */
    $('.event-btn').on('click', function() {
        app47.genericEvent("Generic Event Clicked");
        alert("Generic Event Sent");
    });
 
    /* send a simple log */
    $('.log-btn').on('click', function() {
        app47.info("Log Button Clicked");
        alert("Info Log Sent");
    });

}());
