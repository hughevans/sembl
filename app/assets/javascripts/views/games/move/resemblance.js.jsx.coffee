###* @jsx React.DOM ###

{ResemblanceModal} = Sembl.Games.Move
@Sembl.Games.Move.Resemblance = React.createClass

  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    $(window).on('move.resemblance.change', @handleResemblanceChange)

  componentWillUnmount: ->
    $(window).off('move.node.setThing', @handleSetThing)
    $(window).off('move.resemblance.change', @handleResemblanceChange)


  handleClick: (event, link) ->
    $(window).trigger('move.resemblance.click', {link: @props.link, description: @state.description})

  handleResemblanceChange: (event, resemblance) ->
    if resemblance.link.id == @props.link.id
      @setState
        description: resemblance.description

  handleSetThing: (event, data) ->
    if data.node.id == @props.link.target().id
      round = window.Sembl.game.get('current_round')
      @setState
        linkFilled: true
      if round == 1 and !!!@state.description
        $(window).trigger('flash.notice', 'Top choice!')

  getInitialState: ->
    link = @props.link
    resemblance = link.get('viewable_resemblance')
    description = if !!resemblance then resemblance.description
    state =
      description: description
      nodeState: link.target().get('user_state')
      linkFilled: _.contains @props.placedNodes, link.target().id

  componentDidUpdate: ->
    round = window.Sembl.game.get('current_round')
    if round == 1 and !!@state.description
      $(window).trigger('flash.notice', 'Well assembled, you.')

  render: () ->
    toggleEvent = 'toggle.graph.resemblance.'+@props.link.id

    child = if @state.description
      `<div className="game__resemblance__expanded">
        <div className="game__resemblance__expanded__inner">
          {this.state.description}
        </div>
      </div>`
    else
      `<div className={"game__resemblance__empty"} />`

    tooltip = if @state.linkFilled && !@state.description
      `<div className="game__resemblance__tip">Add a description</div>`
    else
      ""

    `<div className="move__resemblance" onClick={this.handleClick}>
      {tooltip}
      {child}
    </div>`

