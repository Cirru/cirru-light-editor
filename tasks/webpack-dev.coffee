
fs = require('fs')
path = require('path')
precss = require('precss')
webpack = require('webpack')
autoprefixer = require('autoprefixer')
settings = require('./settings')

module.exports = (info) ->
  config = settings.get('dev')
  {
    entry:
      vendor: [
        'webpack-dev-server/client?' + config.host + ':' + config.port
        'webpack/hot/dev-server'
        'react'
        'immutable'
      ]
      main: [ './client/main' ]
    output:
      path: path.join(info.__dirname, 'build/')
      filename: '[name].js'
      publicPath: config.host + ':' + config.port + '/'
    resolve: extensions: [
      '.js'
      '.cirru'
      ''
    ]
    module: loaders: [
      {
        test: /\.cirru$/
        loader: 'cirru-script'
      }
      {
        test: /.(png|jpg|gif|woff2)$/
        loader: 'url-loader'
        query: limit: 100
      }
      {
        test: /\.css$/
        loader: 'style!css?importLoaders=1!autoprefixer'
      }
      {
        test: /\.json$/
        loader: 'json'
      }
    ]
    postcss: ->
      [
        autoprefixer
        precss
      ]
    plugins: [
      new (webpack.optimize.CommonsChunkPlugin)('vendor', 'vendor.js')
      new (webpack.HotModuleReplacementPlugin)
    ]
  }
