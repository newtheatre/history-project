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
  ret = $("#smug-albums").html()
  $(albums).each (i, album) ->
    ret += "<tr class=\"album-row\" data-key=\"#{ album["AlbumKey"] }\"><td>#{ i+1 }</td><td><a href=\"#{ album['WebUri'] }\" class=\"usage-link\">#{ album["Name"] }</a></td><td>#{ album["AlbumKey"] }</td><td>#{ album["ImageCount"] }</td><td class=\"usage\">?</td></tr>\n"
  $("#smug-albums").html(ret)

fill_image_list = (images) ->
  ret = $("#smug-images").html()
  $(images).each (i, image) ->
    ret += "<tr><td>#{ i+1 }</td><td><a href=\"#{ image['WebUri'] }\"><img src=\"#{ image["ThumbnailUrl"] }\" alt=\"Thumb\"/></a><td>#{ image["Title"] }</td><td>#{ image["FileName"] }</td><td><a href=\"#{ image['WebUri'] }\" class=\"usage-link\">#{ image["ImageKey"] }</a></td></tr>\n"
  $("#smug-images").html(ret)

fetch_album_list = (callback) ->
  $.ajax
    url: "/feeds/smug_albums.json"
    method: "GET"
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: callback
    error: (err) ->
      alert "Error: #{err}"

add_used_album_data = (albums) ->
  $.each albums, (albumKey, show) ->
    $("[data-key=#{albumKey}] .usage").html("<a href=\"#{ show['link'] }\" class=\"usage-link\">Y</a>").addClass("yes")

$(document).ready ->
  if $('body').hasClass 'util-smug-albums'
    fetch_sm "user/newtheatre!albums", (data) ->
      window.d = data
      fill_album_list(data["Response"]["Album"])

      fetch_album_list (data) ->
        add_used_album_data(data)

  if $('body').hasClass 'util-smug-album'
    key = $('#smug-images').data("album")
    fetch_sm "album/#{ key }!images", (data) ->
      window.d = data
      fill_image_list(data["Response"]["AlbumImage"])

