#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{GameNode} = Sembl.Components.Graph

@Sembl.Games.Gameboard.Placement = React.createClass
  getInitialState: ->
    gameState: Sembl.game.get("state")

  handleClick: (event, data) ->
    event.preventDefault()
    node = @props.node
    userState = node.get('user_state')
    if userState == 'available' && (@state.gameState is "playing" || @state.gameState is "joining" || @state.gameState is "open")
      setTimeout ->
        Sembl.router.navigate("move/#{node.id}", trigger: true)
      , 0
    else
      thing = node.get('viewable_placement')?.thing
      if thing
        $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

  componentDidMount: ->
    round = window.Sembl.game.get('current_round')
    userState =  @props.node.get('user_state') || @props.userState
    if round == 1 and userState == 'available'
      $(window).trigger('flash.notice', "Let's go! Add your first image to begin the game.")

  render: ->
    node = @props.node
    userState = @props.userState || node.get('user_state')
    playerState = window.Sembl.game.get('player')?.state
    if @state.gameState is "rating" and userState is "available" || userState is "available" and playerState is "waiting" then userState = "locked"
    className = "game__placement state-#{userState} "

    thing = node.get('viewable_placement')?.thing
    image_url = @props.image_url || thing?.image_admin_url

    round = node.game.get('current_round')
    alertedClass = ""
    alertedClass = " alerted" if round == 1 and userState == 'available'

    `<a href="#placement" className={className + alertedClass} onClick={this.handleClick} data-node-id={node.id}>
      <img className="game__placement__image" src={image_url} />
    </a>`


