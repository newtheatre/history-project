_ = require '../../lib/underscore/underscore.js'
lunr = require '../../lib/lunr.js/lunr.js'
fs = require 'fs'

index = lunr ->
  @field 'title',
    boost: 10
  @field 'graduated'
  @field 'careers'
  @field 'course'
  @field 'awards'
  @field 'sroles'
  @field 'croles'

  @ref 'url'

fixArray = (arr, prepend) ->
  for i in _.range(arr.length)
    arr[i] = "#{prepend}:#{arr[i]}".replace(/ /g, '_')
  return arr.join(' ')

fs.readFile './_site/feeds/people.json', (err, data) ->

  raw = JSON.parse data
  reverse_index = new Object

  console.time 'Populate People Index'
  raw.forEach (item) ->
    index.add
      title: item['title']
      graduated: "graduated:#{item['graduated']}"
      careers: fixArray(item['careers'], 'career')
      course: fixArray(item['course'], 'course')
      awards: fixArray(item['awards'], 'award')
      sroles: fixArray(item['sroles'], 'srole')
      croles: fixArray(item['croles'], 'crole')
      url: item['url']
  console.timeEnd 'Populate People Index'

  console.log raw.length + ' people indexed'

  fs.writeFile '_site/feeds/people_index.json', JSON.stringify(index), (err) ->
    throw err if err
    console.log 'People Index Written'
