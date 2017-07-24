;(function(){
  "use strict";

  var app = app || {};

  app.startSelects = function(context){
      var context = context || "body";
      var $self = $(context);
      var placeholder = $("select").attr("placeholder")
      $self.find(".js-select2").each(function(index, element){
          var $element = $(element);
          var placeholder = $element.attr("placeholder") || $element.data("placeholder") || I18n.t("select2.default_simple_placeholder");
          var width = $element.data("width") ? $element.data("width") : undefined;
          var allowClear = $element.data("allowClear") ? $element.data("allowClear") : false;
          $element.select2({placeholder: placeholder, width: width, allowClear: allowClear, locale: I18n.locale});
      });
  };

  app.startDateTimepickers = function(context){
    var context = context || "body";
    var $container = $(context);
    var dateFormat = I18n.t("date.formats.calendar_js").replace(/%/g, "/");
    var hourFormat = "H:i";
    var dateAndTimeFormat = dateFormat + " " + hourFormat;
    //Start DateTimePickers
    $container.find(".js-default-datetimepicker").each(function(){
      var $self = $(this);
      var hourStep = $self.data("hourstep") || 15;
      $self.datetimepicker({
        locale: I18n.locale,
        format: dateAndTimeFormat
      });
    });
  };

  app.startDatepickers = function(context){
    var context = context || "body";
    var $self = $(context);
    var dateFormat = I18n.t("date.formats.calendar_js").replace(/%/g, "/");
    //Start DatePickers
    $self.find(".js-default-datepicker").datetimepicker({
      locale: I18n.locale,
      format: dateFormat
    });
  };

  app.startTimepickers = function(context){
    var context = context || "body";
    var $container = $(context);
    var hourFormat = "H:i";
    //Start TimePickers
    $container.find(".js-default-timepicker").each(function(){
      var $self = $(this);
      var hourStep = $self.data("hourstep") || 15;
      $self.datetimepicker({
        locale: I18n.locale,
        format: hourFormat
      });
    });
  };

  app.startAllPickers = function(context){
    app.startDatepickers(context);
    app.startDateTimepickers(context);
    app.startTimepickers(context);
  }

  app.startSpinner = function(selector){
    var $element= $(selector);
    $element.removeClass("hide").hide().fadeIn();
  }

  app.hideSpinner = function(selector){
    var  $element= $(selector);
    $element.fadeOut(function(){ $element.addClass("hide") });
  }

  app.startCommonEvents = function(context){
    context = context || document;
    $(context).on("click",".js-void-link",function(event){
      return false;
    });
    $(context).on("click",".js-disabled",function(event){
      return false;
    });
  }

  app.startColorPickers = function(context){
    var $context = $(context || "body");
    if(!app.browserSupportsColorPickers()){
      $context.find(".js-color-picker").spectrum({preferredFormat: "hex", showInput: true});
    }
  }

  app.browserSupportsColorPickers = function(){
    var colorInput;
    // NOTE:
    //
    // If the browser is capable of displaying a color picker, it will sanitize the color value first. So "!"" becomes #000000;
    //
    // Taken directly from modernizr:
    // @see http://modernizr.com/docs/#features-html5
    //
    // These types can enable native datepickers, colorpickers, URL validation, and so on.
    // If a browser doesn’t support a given type, it will be rendered as a text field. Modernizr
    // cannot detect that date inputs create a datepicker, the color input create a colorpicker,
    // and so on—it will detect that the input values are sanitized based on the spec. In the
    // case of WebKit, we have received confirmation that sanitization will not be added without
    // the UI widgets being in place.
    colorInput = $('<input type="color" value="!" />')[0];
    return colorInput.type === 'color' && colorInput.value !== '!';
  };

  app.titleize = function(string){
    //string = "domingo 10 de mayo de 2015 15:30"; //Test
    if (string === undefined || string === null || string === "" || (typeof string !== "string") ){
      return string;
    }
    var array = string.split(" ");
    var newString = "";
    var join= " ";
    $(array).each(function(index, element){
      newString += array[index][0].toUpperCase() + array[index].substring(1).toLowerCase() + join;
    });
    return newString.trim();
  }

  app.toHourString = function(number){
    if(number == undefined || number == null){
      return "";
    }
    var string = number.toString();
    var result = string.length > 1 ? string : ("0" + string);
    return result;
  }

  app.flash= function(options){
    var options = typeof options === "string" ? ({message: options}) : (options || {});
    var title   = options.title || "";
    var message = options.message || "";
    var delay = options.delay == 0 ? 0 : (options.delay || 7000);
    var type  = options.type || "success"; // success, warning, info, danger
    $.notify({message: message, title: title}, {type: type, delay: delay});
  }

  app.showFlashMessages= function(options){
    options = options || {};
    var $elements = $(".js-flash-message");
    $elements.each(function(index, element){
      var $element = $(element);
      var type = $element.data("flash");
      var message = $element.data("message");
      var delay = $element.data("delay");
      app.flash({type: type, message: message, delay: (delay || options.delay)});
    })
  }

  app.disable = function (selector){
    var $element = $(selector);
    $element.each(function(){
      $(this).addClass("js-disabled disabled");
    });
    return $element;
  }

  app.enable = function (selector){
    var $element = $(selector);
    $element.each(function(){
      $(this).removeClass("js-disabled disabled");
    });
    return $element;
  }

  app.isDisabled= function(selector){
    var $element = $(selector);
    return $element.hasClass("js-disabled") || $element.hasClass("disabled");
  }

  app.setLocale = function(locale, defaultLocale){
    defaultLocale = defaultLocale || locale;
    I18n.defaultLocale = defaultLocale;
    I18n.locale = locale;
    moment.locale(locale);
  }

  app.locale = function(type){
    if(type && type.toString().toLowerCase() == "all"){
      return { I18n: I18n.locale, moment: moment.locale() };
    }
    else{
      return I18n.locale;
    }
  }

  app.startTooltips = function(context, options){
    var $self = $(context || "body");
    options = options || {};
    $self.find(".js-tooltip").each(function(){
      var $element = $(this);
      var elementOptions = $element.data("tooltip") || {};
      var tooltipOptions =  $.extend({container: "body"}, options, elementOptions);
      $element.tooltip(tooltipOptions);
    });
  }

  app.isBlank = function(object) {
    return object === null || object === undefined || object === '' || object.length <= 0 || (!_.isString(object) && isNaN(object)) || object === NaN || object === "NaN"
  }

  app.isPresent = function(object) {
    return !app.isBlank(object);
  }

  app.clearField = function(selector){
    $(selector).find("input").val("");
  }

  window.app = app;
  
})();
