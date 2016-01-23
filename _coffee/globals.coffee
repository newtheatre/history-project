GITHUB_ISSUES_USER = "newtheatre"
GITHUB_ISSUES_REPO = "history-project"

delay = (ms, func) -> setTimeout func, ms

getUrlParameter = (name) ->
  match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search)
  match and decodeURIComponent(match[1].replace(/\+/g, ' '))

debounce = (fn) ->
  timeout = undefined
  ->
    args = Array::slice.call(arguments)
    ctx = this
    clearTimeout timeout
    timeout = setTimeout((->
      fn.apply ctx, args
      return
    ), 40)
