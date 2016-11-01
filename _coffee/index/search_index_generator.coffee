lunr = require '../../lib/lunr.js/lunr.js'
fs = require 'fs'

index = lunr ->
  @field 'title',
    boost: 10
  @field 'body'
  @field 'keywords',
    boost: 20
  @field 'playwright',
    boost: 5
  @field 'cast',
    boost: 3
  @field 'crew',
    boost: 3
  @field 'type',
    boost: 30
  @ref 'url'

fs.readFile './_site/feeds/search.json', (err, data) ->

  raw = JSON.parse data
  reverse_index = new Object

  console.time 'Populate Search Index'
  raw.forEach (item) ->
    reverse_index[ item['link'] ] = item
    index.add
      title: item['title']
      type: item['type']
      body: item['content']
      playwright: item['playwright']
      cast: item['cast']
      crew: item['crew']
      keywords: item['keywords']
      url: item['link']
  console.timeEnd 'Populate Search Index'

  console.log raw.length + ' pages indexed'

  fs.writeFile '_site/feeds/search_index.json', JSON.stringify(index), (err) ->
      throw err if err
      console.log 'Search Index Written'
  fs.writeFile '_site/feeds/search_index_reverse.json', JSON.stringify(reverse_index), (err) ->
      throw err if err
      console.log 'Reverse Search Index Written'
