$(document).ready ->
  $('#report-this-page').click (e) ->
    e.preventDefault()
    $('#report').addClass 'report-show'
  $('[data-report-close]').click (e) ->
    e.preventDefault()
    $('#report').removeClass 'report-show'

  $('#improve-this-page').click (e) ->
    if localStorage.debug_mode isnt "yes"
      e.preventDefault()
      $('#improve').addClass 'report-show'
  $('[data-improve-close]').click (e) ->
    e.preventDefault()
    $('#improve').removeClass 'report-show'

  $('[data-report-this-page]').click (e) ->
    e.preventDefault()
    $('#improve').removeClass 'report-show'
    $('#report').addClass 'report-show'

$("#report-issue-form").submit (e) ->
  e.preventDefault()

  postData = $(this).serializeArray()
  formURL = $(this).attr 'action'

  $.ajax
    url : formURL
    type: "POST"
    data : postData,

    success: (data, textStatus, jqXHR) ->
      if data.status is "success"
        reportThanks(data.url)
      else
        alert('There was a problem with the data your provided')
        enableForm()

    error: (jqXHR, textStatus, errorThrown) ->
      alert('Oops, something went wrong')
      enableForm();

  disableForm()

disableForm = ->
  $('.report-submit').attr("disabled", true)
  $('.report-submit').addClass('disabled')
  $('.report-submit').html('<i class="fa fa-circle-o-notch fa-spin"></i>')


enableForm = ->
  $('.report-submit').attr("disabled", false)
  $('.report-submit').removeClass('disabled')
  $('.report-submit').html('Try Again')

reportThanks = (url) ->
  template = _.template $('#report-success-template').html()
  $('#report-modal-content').html template('url': url)
