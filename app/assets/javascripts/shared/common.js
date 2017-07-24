;(function(){

    "use strict";

    $(document).ready(function(){
        app.showFlashMessages({delay: 0});
        app.startSelects();
        app.startAllPickers();
        app.startColorPickers();
        app.startTooltips();
        app.startCommonEvents();
    });


})();