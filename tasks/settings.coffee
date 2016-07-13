
exports.get = (env) ->
  switch env
    when 'dev'
      env: 'dev'
      host: 'http://repo'
      port: 8080
    when 'build'
      env: 'build'
      host: 'http://repo'
      port: 8080
