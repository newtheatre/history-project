collectBindEvents = ->
  $('input[type="checkbox"]').change ->
    $(this).closest("label").toggleClass("child-checked", this.checked)

  $("#collect-show-form").submit (e) ->
    e.preventDefault()

    form_data = $(this).serializeArray()
    form_dict = {}

    form_data.forEach (x) ->
      form_dict[x['name']] = x['value']

    message = """# 'Tell us about a show' form submission

Field | Data
----- | ----
Title | #{form_dict['title']}
Playwright | #{form_dict['playwright']}
Date Start | #{form_dict['date_start_day']} / #{form_dict['date_start_month']} / #{form_dict['date_start_year']}
Date End | #{form_dict['date_end_day']} / #{form_dict['date_end_month']} / #{form_dict['date_end_year']}
Type | #{form_dict['type']}
Venue | #{form_dict['venue']}

## Synopsis

#{form_dict['synopsis']}

## Cast

#{form_dict['cast']}

## Crew

#{form_dict['crew']}

## Anything Else

#{form_dict['other']}

## Submitter

Field | Data
----- | ----
Name | #{form_dict['name']}
Graduated | #{form_dict['graduation']}

## Attempted File Generation

```
---
title: #{form_dict['title']}
playwright: #{form_dict['playwright']}
season: ??? (#{form_dict['type']})
season_sort: ??
period: ??
venue:
  - #{form_dict['venue']}
date_start: #{form_dict['date_start_year']}-#{form_dict['date_start_month']}-#{form_dict['date_start_day']}
date_end: #{form_dict['date_end_year']}-#{form_dict['date_end_month']}-#{form_dict['date_end_day']}

cast:
  - role:
    name:

crew:
  - role: Director
    name:
  - role: Producer
    name:

comment: Details from #{form_dict['name']} (#{form_dict['graduation']})
published: true
---

#{form_dict['synopsis']}
```
"""

    postData = {
      'title': form_dict['title'],
      'message': message,
      'name': ''
      'page_url': '/collect/show/'
    }

    report = new ReportModel
      title: form_dict['title']
      message: message,
      name: ''
      page_url: '/collect/show/'
      url: $(this).attr 'action'

    report.save
      success: (data) ->
        Turbolinks.visit('/collect/show/thanks/')
      error: (data) ->
        enableCollectForm()

    disableCollectForm()

  $("#collect-person-form").submit (e) ->
    e.preventDefault()

    form_data = $(this).serializeArray()
    form_dict = {}

    form_data.forEach (x) ->
      form_dict[x['name']] = x['value'].replace(/[^\x00-\x7F]/g, "");

    form_data_computed =
      'contact_allowed_yn': if form_dict['contact_allowed'] == 'on' then 'Yes' else 'No'
      'contact_allowed_tf': if form_dict['contact_allowed'] == 'on' then 'true' else 'false'

    career_choices = []
    career_choices_formatted = ""
    career_choices_yaml = ""
    $('.career-choice').each (x) ->
      if this.checked
        career_choices.push( $(this).attr('name') )
        career_choices_formatted += $(this).attr('name') + ", "
        career_choices_yaml += "  - " + $(this).attr('name') + "\n"

    message = """# 'Submit an alumni bio' form submission

Field | Data
----- | ----
Name | #{form_dict['name']}
Grad Year | #{form_dict['graduation']}
Course | #{form_dict['course']}

## Bio1 (Time at theatre)

#{form_dict['bio1']}

## Bio2 (Post-graduation)

#{form_dict['bio2']}

Field | Data
------| ----
Checked careers | #{career_choices_formatted}
Other careers | #{form_dict['career-other']}

## Links

#{form_dict['links']}

## Shows

#{form_dict['shows']}

## Committees

#{form_dict['committees']}

## Awards

#{form_dict['awards']}

## Contact Preferences

Are we allowed to facilitate contact to this alumnus? **#{form_data_computed['contact_allowed_yn']}**

## Attempted File Generation

```
---
title: #{form_dict['name']}
course:
  - #{form_dict['course']}
graduated: #{form_dict['graduation']}
contact_allowed: #{form_data_computed['contact_allowed_tf']}
careers:
#{career_choices_yaml}
#{form_dict['career-other']}
links: *fill me out
#{form_dict['links']}
award: *fill me out
#{form_dict['awards']}
---

#{form_dict['bio1']}

#{form_dict['bio2']}

```
"""

    window.message = message

    report = new ReportModel
      title: form_dict['name'] + " bio submission"
      message: message,
      name: ''
      page_url: '/collect/person/'
      url: $(this).attr 'action'

    report.save
      success: (data) ->
        Turbolinks.visit('/collect/person/thanks/')
      error: (data) ->
        enableCollectForm()

    disableCollectForm()

PEOPLE_FEED = "/feeds/people-collect.json"
TEMPLATE_DATA = "#collect-template-list"

collectPersonFormSetup = ->
  collectBindEvents()
  path = getUrlParameter('name')
  if path and path.length > 0
    $.get PEOPLE_FEED, (data) ->
      if path of data # (path in data)
        $('[data-have-details-show]').show()
        $('[data-have-details-style]').addClass('collect-has-data')

        $('.collect-field-name').val data[path].name
        $('.collect-field-graduation').val data[path].graduated
        $('.collect-field-course').val data[path].course
        $('.collect-field-bio1').val data[path].bio

        template = _.template $(TEMPLATE_DATA).html()
        for item in data[path].shows
          $('[data-have-details-shows-hide]').hide()
          $("#collect-shows .collect-person-data").append template
            item: item

        for item in data[path].committees
          $('[data-have-details-committees-hide]').hide()
          $("#collect-committees .collect-person-data").append template
            item: item

    , 'json'

disableCollectForm = ->
  $('.collect-submit').attr("disabled", true)
  $('.collect-submit').addClass('disabled')
  $('.collect-submit').html('<i class="fa fa-circle-o-notch fa-spin"></i>')


enableCollectForm = ->
  $('.collect-submit').attr("disabled", false)
  $('.collect-submit').removeClass('disabled')
  $('.collect-submit').html('Try Again')

# Setup

document.addEventListener 'turbolinks:load', ->
  if $('body').hasClass 'collect-person-form'
    collectPersonFormSetup()
