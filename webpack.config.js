
fs = require('fs');
webpack = require('webpack');

module.exports = {
  entry: {
    main: [
      'webpack-dev-server/client?http://0.0.0.0:8080',
      'webpack/hot/dev-server',
      './client/main'
    ]
  },
  output: {
    path: 'build/',
    filename: '[name].js',
    publicPath: 'http://localhost:8080/build/'
  },
  resolve: {
    extensions: ['', '.js', '.cirru']
  },
  module: {
    loaders: [
      {test: /\.cirru$/, loaders: ['react-hot', 'cirru-script'], exclude: /node_modules/},
      {test: /\.png$/, loaders: ['url']},
      {test: /\.css$/, loaders: ['style', 'css']},
    ]
  },
  plugins: [
    function() {
       this.plugin('done', function(stats) {
        content = JSON.stringify(stats.toJson().assetsByChunkName, null, 2)
        return fs.writeFileSync('assets.json', content)
      })
    },
    new webpack.NoErrorsPlugin()
    // new webpack.IgnorePlugin(/ModuleName$/, /jsondiffpatch/)
  ]
}
