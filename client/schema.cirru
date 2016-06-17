
var
  Immutable $ require :immutable

= exports.db $ Immutable.fromJS $ {}
  :device $ {}
    :isConnected false
    :isErrored false
  :collection $ []
