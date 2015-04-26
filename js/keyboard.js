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
