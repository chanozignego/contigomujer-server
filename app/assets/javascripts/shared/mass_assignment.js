;(function(){

  "use strict";

  function massAssignmentModalHandler(link){
    var $self = $(link);
    var $modal = $($self.data("target"));
    var selectedRows = $(".js-mass-assignment-form [name='model_ids[]']:checked")
      .map(function(){return this.value})
      .toArray();
    $modal
      .find(".js-selected-rows")
      .val(selectedRows);
    $modal
      .find(".js-selected-all")
      .prop("checked", $(".js-mass-assignment-check-all").prop("checked") );
    $modal
      .find(".js-batch-action-form")
      .prop("action", $self.data("submitTo"))
      .prop("method", $self.data("submitType"));
    $modal.find(".js-method-name").val($self.data("action"));
    $modal.modal();    
  }

  function massAssignmentHandler(link){
    var $self = $(link);
    $(".js-action").val($self.data("action"));
    $(".js-mass-assignment-form").prop("action", $self.data("submitTo")).submit();
  }

  $(document).on("click", ".js-mass-action-link", function(event){
      var $self = $(this);
      $self.data("target") ? massAssignmentModalHandler($self) : massAssignmentHandler($self) ;
      return false;
  });

  $(document).on("change", ".js-mass-assignment-check-all", function(event){
      var $self = $(this);
      $self.closest(".js-resource-table").find(".js-mass-assignment-check").prop("checked", this.checked);
  });

  $(document).on("show.bs.modal", ".js-mass-assignment-modal", function(event){
    app.startCommonEvents($(this));
  });

  $(document).on("shown.bs.modal", ".js-mass-assignment-modal", function(event){
    //add here behaviour for all mass assignment modals
  });


})();