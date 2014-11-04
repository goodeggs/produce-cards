React = require 'react'

# Source code here
 # loadEggs
 # flipRequested: -> flip
 # nextEggRequested: -> nextEgg
 # -----
 # filter

App =
  render: ->
    <Deck />

  start: (selector) ->
    React.render @render(), document.querySelector(selector)

components = {}

services = {}

models = {}

actions =
  loadEggs: ->
  advance: ->

window.App = App
