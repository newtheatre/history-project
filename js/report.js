$(document).ready(function(){
  $('#report-this-page').click(function(){
    $('#report').addClass('report-show')
    $('#report').fadeIn(400)
  });
  $('[data-report-close]').click(function(){
    $('#report').removeClass('report-show')
    $('#report').fadeOut(400)
  });
});

$("#report-issue-form").submit(function(e)
{
  e.preventDefault(); //STOP default action
  var postData = $(this).serializeArray();
  var formURL = $(this).attr("action");
  $.ajax(
  {
    url : formURL,
    type: "POST",
    data : postData,
    success: function(data, textStatus, jqXHR)
    {
        if (data.status == "success")
        {
            reportThanks(data.url)
        }
        else
        {
            alert('There was a problem with the data your provided')
            enableForm();
        }
    },
    error: function(jqXHR, textStatus, errorThrown)
    {
        alert('Oops, something went wrong')
        enableForm();
    }
  });
  disableForm();
});

function disableForm() {
  $('.report-submit').attr("disabled", true);
  $('.report-submit').addClass('disabled');
  $('.report-submit').html('<i class="fa fa-circle-o-notch fa-spin"></i>');
}

function enableForm() {
  $('.report-submit').attr("disabled", false);
  $('.report-submit').removeClass('disabled');
  $('.report-submit').html('Try Again');
}

function reportThanks(url) {
  template = _.template($('#report-success-template').html());
  $('#report-modal-content').html(
    template({
      'url': url
    })
  );
}
