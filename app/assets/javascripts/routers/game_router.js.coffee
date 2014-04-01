#= require views/games/gameboard/game_view
#= require views/games/gameboard/game_header_view
#= require views/games/move/move_view
#= require collections/moves
#= require views/games/rate/rating_view
#= require views/games/results/results_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "board"
    "move/:node_id": "add_move"
    "results/:round": "results"
    "rate": "rate"

  initialize: (@game) ->
    Sembl.layout = React.renderComponent(
      Sembl.Layouts.Default()
      document.getElementsByTagName('body')[0]
    )

  board: ->
    Sembl.layout.setState 
      body: Sembl.Games.Gameboard.GameView({model: @game}),
      header: Sembl.Games.Gameboard.GameHeaderView(model: @game)

  add_move: (nodeID) ->
    node = @game.nodes.get(nodeID)
    React.renderComponent(
      Sembl.Games.Move.MoveView({node: node, game: @game})
      document.getElementsByTagName('body')[0]
    )

  rate: -> 
    React.unmountComponentAtNode(document.getElementsByTagName('body')[0])
    _this = @
    moves = new Sembl.Moves([], {rating: true, game: @game})
    res = moves.fetch()
    res.done -> 
      React.renderComponent(
        Sembl.Games.Rate.RatingView({moves: moves, game: _this.game}), 
        document.getElementsByTagName('body')[0]
      )

  results: (round) ->
    React.unmountComponentAtNode(document.getElementsByTagName('body')[0])
    results = new Sembl.Results([], {game: @game, round: round})
    res = results.fetch()
    res.done =>
      React.renderComponent(
        Sembl.Games.Results.ResultsView({results: results, game: @game})
        document.getElementsByTagName('body')[0]
      )

