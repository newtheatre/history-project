api_key = "fCXo05bxAfCoY31I5vtcmPr8AEY3uQTr"

fetch_sm = (url, callback) ->
  $.ajax
    url: "https://www.smugmug.com/api/v2/#{ url }?APIKey=#{ api_key }&count=5000"
    method: "GET"
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: callback
    error: (err) ->
      alert "Error: #{err}"

fill_album_list = (albums) ->
  ret = ""
  $(albums).each (i, album) ->
    ret += "<tr class=\"album-row\" data-key=\"#{ album["AlbumKey"] }\"><td><a href=\"#{ album['WebUri'] }\" class=\"usage-link\">#{ album["Name"] }</a></td><td>#{ album["AlbumKey"] }</td><td>#{ album["ImageCount"] }</td><td class=\"usage\">?</td></tr>\n"
  $("#smug-albums tbody").html(ret)

fill_image_list = (images) ->
  ret = ""
  $(images).each (i, image) ->
    ret += "<tr class=\"image-row\" data-key=\"#{ image["ImageKey"] }\"><td><a href=\"#{ image['WebUri'] }\"><img src=\"#{ image["ThumbnailUrl"] }\" alt=\"Thumb\"/></a><td>#{ image["Title"] }</td><td>#{ image["FileName"] }</td><td>#{ image["ImageKey"] }</td><td class=\"usage\">?</td></tr>\n"
  $("#smug-images tbody").html(ret)

fetch_usage_list = (url, callback) ->
  $.ajax
    url: url
    method: "GET"
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: callback
    error: (err) ->
      alert "Error: #{err}"

add_usage_data = (albums) ->
  $.each albums, (albumKey, show) ->
    $("[data-key=#{albumKey}] .usage").html("<a href=\"#{ show['link'] }\" title=\"#{ show['title'] }\"
                                                class=\"usage-link\">Y</a>").addClass("yes")

$(document).ready ->
  if $('body').hasClass 'util-smug-albums'
    fetch_sm "user/newtheatre!albums", (data) ->
      window.d = data
      fill_album_list(data["Response"]["Album"])

      fetch_usage_list "/feeds/smug_albums.json", (data) ->
        add_usage_data(data)
        $("#smug-albums").tablesorter()



  if $('body').hasClass 'util-smug-album'
    key = $('#smug-images').data("album")
    fetch_sm "album/#{ key }!images", (data) ->
      window.d = data
      fill_image_list(data["Response"]["AlbumImage"])

      # Show assets
      if key == "C87GJX" or key == "j3PdMh"
        fetch_usage_list "/feeds/smug_images.json", (data) ->
          add_usage_data(data)
          $("#smug-images").tablesorter()
      # Headshots
      if key == "hZh8Jt"
        fetch_usage_list "/feeds/smug_headshots.json", (data) ->
          add_usage_data(data)
          $("#smug-images").tablesorter()
      # Venues
      if key == "BdFr84"
        fetch_usage_list "/feeds/smug_venues.json", (data) ->
          add_usage_data(data)
          $("#smug-images").tablesorter()



