Mousetrap.bind('left', function() {
  if ('jekyll_page_previous' in window) {
    window.location.href = jekyll_page_previous;
  }
});
Mousetrap.bind('right', function() {
  if ('jekyll_page_next' in window) {
    window.location.href = jekyll_page_next;
  }
});
Mousetrap.bind('up', function() {
  console.log('up')
  if ('jekyll_page_up' in window) {
    window.location.href = jekyll_page_up;
  }
});

Mousetrap.bind('e d i t o r', function() {
  console.log('debug')
  if (localStorage.debug_mode == "yes") {
    // Disable
    localStorage.debug_mode = "no"
    $('[data-debug-toggle]').hide()
  }
  else {
    // Enable
    localStorage.debug_mode = "yes"
    $('[data-debug-toggle]').show()
  }

});

$(document).ready(function(){
  if (localStorage.debug_mode == "yes") {
    $('[data-debug-toggle]').show()
  }
});