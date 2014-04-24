#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{Node} = Sembl.Components.Graph

@Sembl.Games.Move.Placement = React.createClass
  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    
  componentWillUnmount: ->
    $(window).off('move.node.setThing', @handleSetThing)

  componentDidMount: -> 
    round = window.Sembl.game.game.get('current_round')
    if round == 1 and @state.userState == 'available'
      $(window).trigger('flash.notice', "First, choose an image from the gallery")

  componentDidUpdate: -> 
    round = window.Sembl.game.get('current_round')
    if round == 1 and @state.userState == 'proposed'
      console.log "triggering alert"
      $(window).trigger('flash.notice', 'Now make a creative connection between the images')
  

  handleClick: (event, data) ->
    if @state.thing
      $(window).trigger('modal.open', `<ThingModal thing={this.state.thing} />`)

  handleSetThing: (event, data) ->
    if data.node.id == @props.node.id
      console.log "handle set thing in placement"
      @setState
        thing: data.thing
        userState: 'proposed'

  getInitialState: ->
    node = @props.node
    thing = node.get('viewable_placement')?.thing

    state = 
      userState: node.get('user_state')
    if thing
      state.thing = thing
    return state

  render: () ->
    round = @props.node.game.get('current_round')

    alertedClass = " alerted" if round == 1 and @state.userState == 'available'

    userState = @state.userState
    className = "game__placement state-#{userState}"
    image_url = @state.thing?.image_admin_url

    `<div className={className + alertedClass} onClick={this.handleClick}>
      <img className="game__placement__image" src={image_url} />
    </div>`



