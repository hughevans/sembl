#= require es5-shims
#= require jquery
#= require jquery.color
#= require jquery.ba-dotimeout
#= require underscore
#= require backbone
#= require react
#= require react.backbone
#= require_self
#= require models/game
#= require models/user
#= require models/move
#= require models/result
#= require collections/results
#= require routers/game_router
#= require viewloader
#= require views/uploader/contributions_view
#= require views/uploader/avatar_view
#= require views/utils/masthead
#= require views/games/index
#= require views/games/setup/new_view
#= require views/games/setup/edit_view
#= require views/components/flash_message

@Sembl =
  version: "0.1"

_.extend Sembl, Backbone.Events

@Sembl.Handlers = @Sembl.Handlers || {}
@Sembl.Utils = @Sembl.Utils || {}
@Sembl.Components = @Sembl.Components || {}
@Sembl.Components.Graph = @Sembl.Components.Graph || {}
@Sembl.Games = @Sembl.Games || {}
@Sembl.Games.Setup = @Sembl.Games.Setup || {}
@Sembl.Games.Gameboard = @Sembl.Games.Gameboard || {}
@Sembl.Games.Move = @Sembl.Games.Move || {}
@Sembl.Games.Rate = @Sembl.Games.Rate || {}
@Sembl.Games.Results = @Sembl.Games.Results || {}
@Sembl.Layouts = @Sembl.Layouts || {}
@Sembl.Masthead = @Sembl.Masthead || {}
@Sembl.views = @Sembl.views || {}

init = ->
  viewloader.execute Sembl.views

$(document).on("page:change", init).ready init
