;(function(){

    "use strict";
    
    var app = window.app || {};

    var customTemplate= "<div data-notify='container' class='col-xs-11 col-sm-3 alert alert-{0} bootstrap-growl-notification' role='alert'><button type='button' aria-hidden='true' class='close' data-notify='dismiss'>×</button><span data-notify='icon'></span><span data-notify='title'>{1}</span><span data-notify='message'>{2}</span></div><a href='{3}' target='{4}' data-notify='url'></a></div>";
    var originalTemplate ="<div data-notify='container' class='col-xs-11 col-sm-3 alert alert-{0}' role='alert'><button type='button' aria-hidden='true' class='close' data-notify='dismiss'>×</button><span data-notify='icon'></span><span data-notify='title'>{1}</span><span data-notify='message'>{2}</span><div class='progress' data-notify='progressbar'><div class='progress-bar progress-bar-{0}' role='progressbar' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100' style='width: 0%;'></div></div><a href='{3}' target='{4}' data-notify='url'></a></div>";

    app.flashContainers = {
        customTemplate: customTemplate,
        originalTemplate: originalTemplate
    };

    $.notifyDefaults({
        template: app.flashContainers.customTemplate,
        delay: 5000,
        showProgressbar: true,
        animate:{
            enter: "animated fadeInUp",
            exit: "animated fadeOutDown"
        }
    });

    window.app = app;

})();
