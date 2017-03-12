App.notifications = App.cable.subscriptions.create("NotificationsChannel", {

  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    //  toastr.info(data.text, "", {positionClass: "toast-top-full-width"});
     $('#notifications').html(data.html);
  }

});
