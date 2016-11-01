# Imports
importScripts('/lib/lunr.js/lunr.min.js')

# Functions
getJSON = (url, successHandler, errorHandler) ->
  xhr = new XMLHttpRequest()
  xhr.open('get', url, true)
  xhr.responseType = 'json'
  xhr.onload = ->
    if (xhr.status)
      successHandler && successHandler(xhr.response)
    else
      errorHandler && errorHandler(xhr.status)
  xhr.send()

# SearchWorker class
class SearchWorker
  constructor: (opts) ->
    @indexUrl = opts.indexUrl
    @dataUrl = opts.dataUrl

    @searchIndex = null
    @dataIndex = null
    @dataReverseIndex = null

    @loadIndex()
    @loadData()

  loadIndex: ->
    getJSON @indexUrl, (data) =>
      @processIndex(data)
    , @fail

  loadData: ->
    getJSON @dataUrl, (data) =>
      @processData(data)
    , @fail

  processIndex: (data) ->
    @searchIndex = lunr.Index.load(data)
    @ready()

  processData: (data) ->
    @dataIndex = data
    @dataReverseIndex = new Object
    for item in data
      @dataReverseIndex[item.url] = item
    @ready()

  ready: ->
    # Two concurent operations, only fire when both ready
    if @searchIndex? and @dataReverseIndex?
      self.postMessage
        cmd: 'ready'

  fail: (status) ->
    console.log ("SearchWorker load error: #{status}")

  search: (query) ->
    indexResults = @searchIndex.search(query)

    # Map index results to data results
    dataResults = Array()
    for ir in indexResults
      dataResults.push @dataReverseIndex[ir.ref]

    # Sort the results array
    dataResults.sort (a,b) ->
      a = "#{a.surname} #{a.forename}".toLowerCase()
      b = "#{b.surname} #{b.forename}".toLowerCase()
      return +(a > b) || +(a == b) - 1

    return {
      cmd: 'results'
      results: dataResults
    }

# Define worker pointer
self.searchWorker = null

# Worker bindings
self.addEventListener 'message', (e) ->
  data = e.data
  switch (data.cmd)
    when 'init'
      self.searchWorker = new SearchWorker
        indexUrl: data.indexUrl
        dataUrl: data.dataUrl
    when 'search'
      results = self.searchWorker.search(data.query)
      self.postMessage(results)
    when 'stop'
      delete self.searchWorker
      self.close()
