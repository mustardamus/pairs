fs   = require('fs')
path = require('path')

module.exports = class Stats
  constructor: ->
    @rootDir  = path.join(path.dirname(fs.realpathSync(__filename)), '..')
    @statsDir = "#{@rootDir}/statistics"

  getCount: (statFile) ->
    count = fs.readFileSync("#{@statsDir}/#{statFile}.txt", 'utf8')
    +count

  incFile: (statFile) ->
    count = @getCount(statFile) + 1
    fs.writeFileSync "#{@statsDir}/#{statFile}.txt", count

  incVisits: ->
    @incFile 'visits'

  incPairs: ->
    @incFile 'pairings'

  getStats: ->
    {
      visits: @getCount('visits')
      pairs : @getCount('pairings')
    }