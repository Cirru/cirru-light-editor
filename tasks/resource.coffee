
exports.get = (config) ->
  switch config.env
    when 'dev'
      vendor: config.host + ':' + config.port + '/vendor.js'
      main: config.host + ':' + config.port + '/main.js'
      style: null
    when 'build'
      assets = require('./assets')

      main: assets.main[0]
      vendor: assets.vendor
      style: assets.main[1]
