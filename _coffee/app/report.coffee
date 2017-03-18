class ReportModel
  constructor: (opts) ->
    @title = opts.title
    @page_url = opts.page_url
    @message = opts.message
    @name = opts.name
    @url = opts.url

  buildJSON: =>
    JSON.stringify
      title: @title
      page_url: @page_url
      message: @message
      name: @name

  save: (opts) ->
    FORM_URL = @url
    data = @buildJSON()
    window.reportModelData = data
    $.ajax
      url : FORM_URL
      type: "POST"
      data : data
      success: (data, textStatus, jqXHR) ->
        if data.status is "success"
          opts.success(data)
        else
          alert('There was a problem with the data your provided')
          opts.error()
      error: (jqXHR, textStatus, errorThrown) ->
        alert('Oops, something went wrong')
        error()

disableReportForm = ->
  $('.report-submit').attr("disabled", true)
  $('.report-submit').addClass('disabled')
  $('.report-submit').html('<i class="fa fa-circle-o-notch fa-spin"></i>')


enableReportForm = ->
  $('.report-submit').attr("disabled", false)
  $('.report-submit').removeClass('disabled')
  $('.report-submit').html('Try Again')

reportThanks = (url) ->
  template = _.template $('#report-success-template').html()
  $('#report-modal-content').html template('url': url)

document.addEventListener 'turbolinks:load', ->
  $('#report-this-page').click (e) ->
    e.preventDefault()
    $('#report').addClass 'report-show'
  $('[data-report-close]').click (e) ->
    e.preventDefault()
    $('#report').removeClass 'report-show'
    $('#improve').removeClass 'report-show'

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

    report = new ReportModel
      title: $("#report-title", this).val()
      page_url: $("#report-page_url", this).val()
      message: $("#report-message", this).val()
      name: $("#report-name", this).val()
      url: $(this).attr 'action'

    report.save
      success: (data) ->
        reportThanks(data.url)
      error: (data) ->
        enableReportForm()

    disableReportForm()
