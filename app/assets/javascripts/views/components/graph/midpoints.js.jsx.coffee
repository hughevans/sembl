#= require d3
#= require raphael

###* @jsx React.DOM ###

Midpoint = React.createClass
  lineFunction: d3.svg.diagonal()
  render: ->
    {link, midpointFactory} = @props
    path = @lineFunction(link)
    length = Raphael.getTotalLength(path)
    midpoint = Raphael.getPointAtLength(path, length / 2)

    positionStyle =
      left: midpoint.x
      top: midpoint.y

    `<div className="graph__midpoint" style={positionStyle}>
      {midpointFactory.createComponent(link, {
        midpointPosition: midpoint,
        sourceNode: this.props.sourceNode,
        targetNode: this.props.targetNode,
        scaledSourceNode: this.props.scaledSourceNode,
        scaledTargetNode: this.props.scaledTargetNode,
        scaledLink: link
      })}
    </div>`

@Sembl.Components.Graph.Midpoints = React.createClass
  render: ->
    {links, midpointFactory} = @props
    midpoints = for link in @props.links
      sourceNode = _.find @props.nodeModels, (node) -> node.get("id") == link.source.id
      targetNode = _.find @props.nodeModels, (node) -> node.get("id") == link.target.id

      scaledSourceNode = _.find @props.scaledNodes, (node) -> node.id == link.source.id
      scaledTargetNode = _.find @props.scaledNodes, (node) -> node.id == link.target.id

      `<Midpoint key={link.key} link={link} midpointFactory={midpointFactory} sourceNode={sourceNode} targetNode={targetNode} scaledSourceNode={scaledSourceNode} scaledTargetNode={scaledTargetNode} />`

    `<div className="graph__midpoints">
      {midpoints}
    </div>`
