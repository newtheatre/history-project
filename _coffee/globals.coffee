window.GITHUB_ISSUES_USER = "newtheatre"
window.GITHUB_ISSUES_REPO = "history-project"

window.getUrlParameter = (name) ->
  match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search)
  match and decodeURIComponent(match[1].replace(/\+/g, ' '))

window.debounce = (fn) ->
  timeout = undefined
  ->
    args = Array::slice.call(arguments)
    ctx = this
    clearTimeout timeout
    timeout = setTimeout((->
      fn.apply ctx, args
      return
    ), 40)
