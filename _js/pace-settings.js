(function(window) {
  window.paceOptions = {
    // Disable the 'elements' source
    ajax: true,
    elements: true,
    eventLag: false,

    // Only show the progress on regular and ajax-y page navigation,
    // not every request
    restartOnRequestAfter: false,
    restartOnPushState: false
  }
}) (window);
