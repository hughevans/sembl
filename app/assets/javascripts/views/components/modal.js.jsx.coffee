###* @jsx React.DOM ###

ESC_KEY = 27

@Sembl.Components.Modal = React.createClass
  componentWillMount: ->
    $(window).on('modal.open', @handleOpen)
    $(window).on('modal.close', @handleClose)
    $('body').on('click', @handleBackgroundClick)

  componentWillUnmount: ->
    $(window).off('modal.open')
    $(window).off('modal.close')
    $('body').off('click')

  handleOpen: (event, modalChild) ->
    @setState
      modalChild: if typeof(modalChild) == "function" then modalChild() else modalChild

  handleBackgroundClick: (event) ->
    if not $.contains(@getDOMNode(), event.target)
      @handleClose()
      $('body').addClass('modal-is-active');

  handleClose: ->
    @setState
      modalChild: null
    $('body').removeClass('modal-is-active')

  getInitialState: ->
    modalChild: null

  render: ->
    if this.state.modalChild
      `<div className="modal">
        <button className="move__thing__modal__button" onClick={this.handleClose}>
          <i className="fa fa-times"></i> close
        </button>
        {this.state.modalChild}
      </div>`
    else
      `<div />`
