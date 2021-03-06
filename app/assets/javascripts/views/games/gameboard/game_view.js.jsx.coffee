#= require views/games/gameboard/game_graph
#= require views/games/gameboard/players_view
#= require views/games/gameboard/status_view
#= require views/layouts/default
#= require jquery.timer

###* @jsx React.DOM ###

{GameGraph, PlayersView, StatusView} = Sembl.Games.Gameboard

Sembl.Games.Gameboard.GameView = React.createBackboneClass
  handleJoin: ->
    postData = authenticity_token: @model().get('auth_token')
    result = $.post "#{@model().url()}/join.json", postData, (data) =>
      @model().fetch()
      $(window).trigger('flash.notice', "Let's go! Add your first image to begin the game.")

    result.fail (response) ->
      responseObj = JSON.parse response.responseText;
      if response.status == 422
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))
      else
        $(window).trigger('flash.error', "Error joining game: #{responseObj.errors}")

  handleEndTurn: ->
    postData = authenticity_token: @model().get('auth_token')
    result = $.post "#{@model().url()}/end_turn.json", postData, (data) =>
      @model().set(data)
      if @model().get('player')?.state == 'rating'
        $(window).trigger('flash.notice', "Round complete! Beginning rating...")
        setTimeout =>
          @redirectOnStateChange('playing_turn')
        , 1000
      else
        $(window).trigger('flash.notice', "Nice, your turn is complete.")

    result.fail (response) ->
      responseObj = JSON.parse response.responseText;
      if response.status == 422
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))
      else
        $(window).trigger('flash.error', "Error ending turn: #{responseObj.errors}")

  getInitialState: ->
    showIntroText: @model().get("player")?.user && !@model().get("player")?.user.has_moved && !!!@model().get("intro_seen")

  componentWillMount: ->
    $(window).on('resize', @handleResize)
    $(window).on('header.joinGame', @handleJoin)

  componentDidMount: ->
    @handleResize()

    @timer = $.timer =>
      previousState = @model().get('player')?.state
      res = @model().fetch()
      res.done =>
        @redirectOnStateChange(previousState)

    @timer.set
      time: 10000
      autostart: true

  componentDidUpdate: ->
    @handleResize()

  componentWillUnmount: ->
    $(window).off('resize', @handleResize)
    $(window).off('header.joinGame', @handleJoin)
    @timer.stop()

  handleResize: ->
    mastheadHeight = $('.masthead').height()
    windowHeight = $(window).height()
    $(@refs.graph.getDOMNode()).css('height', (windowHeight - mastheadHeight) + 'px')
    $(window).trigger('graph.resize')

  redirectOnStateChange: (previousState) ->
    currentState = @model().get('player')?.state
    if currentState == "rating" and currentState != previousState
      Sembl.router.navigate("rate", trigger: true)
    else if currentState == "playing_turn" and currentState != previousState
      roundResults = @model().resultsAvailableForRound()
      if roundResults > 0
        Sembl.router.navigate("results/#{roundResults}", trigger: true)

  hideIntroMessage: (e) ->
    e?.preventDefault()
    @model().set("intro_seen", true)
    @setState showIntroText: false

  formatIntroMessage: ->
    introClass = if @state.showIntroText is true then "game__intro game__intro--show" else "game__intro"
    `<div className={introClass}>
      <div className="game__intro__inner copy">
        <h3>How to play</h3>
        <p>In each Round, for every open node, place an image and 'sembl' it: craft a resemblance between it and the image/s already on the board.</p>
        <p>The challenge is to be interesting – other players will rate your sembls on a sliding scale.</p>
        <button onClick={this.hideIntroMessage}>Got it!</button>
      </div>
    </div>`

  render: ->
    # this width and height will be used to scale the x,y values of the nodes into the width and height of the graph div.
    game = @model()

    `<div className="game">
      <div className="body-wrapper">
        <div className="body-wrapper__outer">
          <div className="body-wrapper__inner">
            <div ref="graph" className="game__graph">
              <GameGraph game={game} />
            </div>
          </div>
        </div>
      </div>
      <PlayersView players={this.model().players} />
      <StatusView game={game} handleEndTurn={this.handleEndTurn} />
      {this.formatIntroMessage()}
    </div>`


