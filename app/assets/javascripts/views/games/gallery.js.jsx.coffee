###* @jsx React.DOM ###

class TempImage
  constructor: (@item, @handleLoaded) ->
    @image = new Image()
    @image.onload = @_handleLoaded
    @image.src = @item.src

  _handleLoaded: =>
    @item.height = @image.height
    @item.width = @image.width
    @handleLoaded(@item)

class Justifiedlayout
  constructor: (@opts) ->

  fitRows: (items) ->
    containerWidth = @opts.containerWidth || 10
    rowHeight = @opts.rowHeight

    totalWidth = 0
    totalItems = items.length
    itemIndex = 0
    rowIndex = 0
    rows = []

    # Iterate through rows, they'll *all* be smaller than the rowHeight
    while totalWidth < containerWidth && itemIndex < totalItems
      item = items[itemIndex]
      newItem = _.extend({}, item)
      if item && item.height && item.width
        lineRatio = rowHeight / item.height
        newItem.width = item.width * lineRatio
        newItem.height = rowHeight
        
        # Set up array for each row
        rows[rowIndex] = rows[rowIndex] || {items: []}

        rows[rowIndex].items.push(newItem)
        totalWidth = totalWidth + newItem.width
      itemIndex = itemIndex + 1
      if rows[rowIndex]
        rows[rowIndex].adjustmentRatio = 1

      # Start next row
      if totalWidth > containerWidth
        rows[rowIndex].adjustmentRatio = (containerWidth / totalWidth)
        totalWidth = 0
        rowIndex = rowIndex + 1

    outRows = for row in rows
      outRow = for item in row.items || []
        item.width = Math.floor(item.width * row.adjustmentRatio)
        item.height = Math.floor(rowHeight * row.adjustmentRatio)
        item
      outRow
    return outRows


GalleryImage = React.createClass
  handleClick: (event) ->
    image = @props.image
    if image.clickEvent
      console.log 'click', image.clickEvent
      $(window).trigger(image.clickEvent, image.thing)

  render: ->
    image = @props.image
    `<img key={image.id} className={image.className} onClick={this.handleClick}
      src={image.src} width={image.width} height={image.height}
      onClick={this.handleClick}
      style={{'display': 'inline-block'}} />`

@Sembl.Games.Gallery = React.createClass
  className: "games__gallery"

  getInitialState: () ->
    things: []
    first: false
    images: @props.images || []
    imagesDerived: if @props.images
        for image in @props.images
          _.extend({}, image)
      else 
        []
    rows: []

  componentWillMount: () ->
    $(window).on("#{@props.searcherPrefix}.updated", @handleSearchUpdated)
    @tempImages = []

  componentWillUnmount: () ->
    $(window).off("#{@props.eventPrefix}.loaded")
    $(window).off("#{@props.searcherPrefix}.updated")

  componentDidMount: ->
    @setState
      containerWidth: $(@getDOMNode()).innerWidth()

  componentDidUpdate: ->

  handleSearchUpdated: (event, data) ->
    items = @state.images || []
    for i,thing of data.things
      itemIndex = parseInt(i, 10) + parseInt(data.offset, 10)
      item = {
        id: thing.id
        src: thing.image_browse_url
        thing: thing
        className: 'games__gallery__thing'
        clickEvent: "#{@props.eventPrefix}.thing.click"
      }
      if !items[itemIndex]      
        items[itemIndex] = item
        @tempImages.push({id: item.id, image: new TempImage(item, @handleTempImageLoad)})
    @setState 
      images: items
      scrollWaypoint: !!data.things # is there new things

  handleScrollWaypoint: ->
    @setState
      scrollWaypoint: false
    @handleNextPage()


  handleNextPage: (event) ->
    $(window).trigger("#{@props.searcherPrefix}.nextPage")
    event?.preventDefault()

  handlePreviousPage: (event) ->
    $(window).trigger("#{@props.searcherPrefix}.previousPage")
    event?.preventDefault()

  handleTempImageLoad: (item) ->
    $.doTimeout('imagesloaded', 200, @triggerRender)

  triggerRender: ->
    @setState {null: null}

  render: ->
    rowHeight = @props.rowHeight || 200
    containerWidth = @state.containerWidth
    justifiedLayout = new Justifiedlayout({containerWidth: containerWidth, rowHeight: rowHeight})
    
    rows = justifiedLayout.fitRows(@state.images)

    scrollWaypointRow = Math.max(0, rows.length - 10)

    rowComponents = for i,row of justifiedLayout.fitRows(@state.images)
      rowImages = for image in row || []
        `<GalleryImage key={image.id} image={image} />`

      if @state.scrollWaypoint && parseInt(i, 10) >= scrollWaypointRow
        `<div key={i} className="gallery__row" onMouseOver={this.handleScrollWaypoint}>
          {rowImages}
        </div>`
      else
        `<div key={i} className="gallery__row">
          {rowImages}
        </div>`


    `<div className={this.className}>
      <button onClick={this.handlePreviousPage} className={this.className + "__previous"}><i className="fa fa-chevron-left"></i> Previous page</button>
      <button onClick={this.handleNextPage} className={this.className + "__next"}>Next page <i className="fa fa-chevron-right"></i></button>
      {rowComponents}
    </div>`

