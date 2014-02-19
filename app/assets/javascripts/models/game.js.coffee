#= require collections/nodes
#= require collections/links
#= require collections/players

class Sembl.Game extends Backbone.Model
  urlRoot: "/games"

  initialize: (options) ->
    @nodes = new Sembl.Nodes(@get("nodes"), game: this)
    @links = new Sembl.Links(@get("links"), game: this)
    @players = new Sembl.Players(@get("players"), game: this)
    
    @listenTo(@, 'change:players', @updatePlayers)
    @listenTo(@, 'change:nodes', @updateNodes)

  filter: ->
    @.attributes.filter

  updatePlayers: -> 
    @players.reset(@get("players"))
    console.log 'reset players'

  updateNodes: -> 
    @nodes.reset(@get("nodes"))
    console.log 'reset nodes'
    
  width: ->
    _(@nodes.pluck("x")).max() + 30 + 50

  height: ->
    _(@nodes.pluck("y")).max() + 30 + 50

  hasErrors: -> 
    @get('errors') is not null and @get('errors').length > 0

  canJoin: -> 
    !@get('is_participating') and !@get('is_hosting') and (@get('state') is 'open' or @get('state') is 'joining') 