#= require d3
#= require views/games/move/actions
#= require views/games/move/board
#= require views/games/move/selected_thing
#= require views/layouts/default
#= require views/games/gallery
#= require views/games/header_view
#= require handlers/gallery_filter_handler
#= require views/components/graph/graph

###* @jsx React.DOM ###

{Actions, Board, SelectedThing} = Sembl.Games.Move
{Gallery} = Sembl.Games
Layout = Sembl.Layouts.Default
Graph = Sembl.Components.Graph.Graph

class MoveGraphLayout 
  constructor: (sources, targets) ->
    rootNode = _.extend({children: sources}, targets)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

@Sembl.Games.Move.MoveView = React.createClass
  
  componentWillMount: ->
    @galleryFilterHandler = new Sembl.Handlers.GalleryFilterHandler(@props.game.get('filter'))
    @galleryFilterHandler.bind()
    $(window).on('graph.node.click', @handleNodeClick)
    $(window).on('move.target.selectThing', @handleSelectTargetThing)

  componentDidMount: ->
    @galleryFilterHandler.handleSearch()

  componentWillUnmount: ->
    @galleryFilterHandler.unbind()
    $(window).off('graph.node.click')
    $(window).off('move.target.selectThing')

  handleNodeClick: (event, node) ->
    userState = node.get('user_state')
    if userState == 'available'
      console.log 'selected available'
  
  handleSelectTargetThing: (event, thing) ->
    console.log 'selected thing', thing
    target = @state.target
    targetThing = thing
    viewablePlacement = 
      image_thumb_url: thing.image_admin_url
      image_url: thing.image_browse_url
      title: thing.title
    target.set('viewable_placement', 
      viewablePlacement
    )

    @setState
      target: target
      targetThing: targetThing

  getInitialState: () ->
    target: @props.node

  handleSubmitMove: () ->
    params = {move: this.state.move}
    console.log params
    url = "/api/moves.json"
    # TODO: this should be POST, but get is helpful for debugging.
    $.get(
      url
      params,
      (move_status) ->
        console.log move_status
      "json"
    )

  render: -> 
    move = new Sembl.Move({
      node: @props.node, 
      thing: null,
      resemblances: []
    })

    game = @props.game
    target = @state.target
    links = game.links.where({target_id: target.id})
    sources = (link.source() for link in links)

    rootNode = _.extend({children: sources}, target)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

    header = `<HeaderView game={this.model()} >
      Your Move
    </HeaderView>`

    `<Layout className="game" header="header">
      <div className="move">
        <Graph nodes={nodes} links={links} />
        <Actions />
        <Gallery SelectedClass={SelectedThing} />
      </div>
    </Layout>`