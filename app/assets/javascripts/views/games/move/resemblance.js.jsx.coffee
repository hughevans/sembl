###* @jsx React.DOM ###

{ResemblanceModal} = Sembl.Games.Move
@Sembl.Games.Move.Resemblance = React.createClass

  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    $(window).on('move.resemblance.change', @handleResemblanceChange)

  componentWillUnmount: ->
    $(window).off('move.node.setThing')
    $(window).off('move.resemblance.change')

      
  handleClick: (event, link) ->
    $(window).trigger('move.resemblance.click', {link: @props.link, description: @state.description})

  handleResemblanceChange: (event, resemblance) ->
    if resemblance.link.id == @props.link.id
      @setState
        description: resemblance.description

  handleSetThing: (event, data) -> 
    if data.node.id == @props.link.target().id
      @setState
        nodeState: 'proposed'

  getInitialState: ->
    console.log 'resemblance props', @props
    link = @props.link
    resemblance = link.get('viewable_resemblance')
    description = if !!resemblance then resemblance.description
    state = 
      description: description
      nodeState: link.target().get('user_state')

  render: () ->
    toggleEvent = 'toggle.graph.resemblance.'+@props.link.id

    round = @props.link.game.get('current_round')
    if round == 1 and !@state.description and @state.nodeState == 'proposed'
      alertedClass = " alerted" 
      $(window).trigger('flash.notice', 'Now make a creative connection between the images')
    else if round == 1 and !!@state.description
      $(window).trigger('flash.notice', 'Happy with your move? Submit to keep playing')

    child = if @state.description 
      `<div className="game__resemblance__expanded">
        <div className="game__resemblance__expanded__inner">
          {this.state.description}
        </div>
      </div>`
    else
      `<div className={"game__resemblance__empty" + alertedClass} />`

    `<div className="move__resemblance" onClick={this.handleClick}>
      {child}
    </div>`

