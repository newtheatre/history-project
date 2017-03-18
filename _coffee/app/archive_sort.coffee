ARCHIVE_SORT_LIST = "#archive-sort-list"
SORT_DROPDOWN = "#archive-sort-dropdown"

sort_items = (container, sort_key) ->
  # Sort items in container by given sort_key in data
  # Array.prototype.sort() takes a compare function
  sorted_items = $(container).children().sort (a_elem, b_elem) ->
    a = $(a_elem).data(sort_key)
    b = $(b_elem).data(sort_key)
    a_alpha = $(a_elem).data("alpha")
    b_alpha = $(b_elem).data("alpha")
    if sort_key == "alpha"
      # String comparison is case sensitive
      a = a.toLowerCase()
      b = b.toLowerCase()
      # From https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort#Sorting_with_map
      return +(a > b) || +(a == b) - 1
    else
      if b - a != 0
        # Sort based on non-equal sort ints
        return b - a
      else
        # Sort ints are equal, secondary sort on alpha
        return +(a_alpha > b_alpha) || +(a_alpha == b_alpha) - 1
  # Replace containers elements with sorted ones
  $(container).html(sorted_items)

document.addEventListener 'turbolinks:load', ->
  $(SORT_DROPDOWN).change ->
    sort_items(ARCHIVE_SORT_LIST, $(this).val())

