{Dispatcher} = require 'flux'

module.exports = class AppDispatcher extends Dispatcher
  handleViewAction: (action) ->
    @dispatch
      source: 'VIEW_ACTION'
      action: action
