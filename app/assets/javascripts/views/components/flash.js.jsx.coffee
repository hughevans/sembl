###* @jsx React.DOM ###

@Sembl.Components.Flash = React.createClass

  getInitialState: ->
    msg: ""
    className: "hidden"

  componentWillMount: ->
    $(window).on('flash.notice', @handleNotice)
    $(window).on('flash.error', @handleError)
    $(window).on('flash.hide', @handleHide)

  componentWillUnmount: ->
    $(window).off('flash.notice', @handleNotice)
    $(window).off('flash.error', @handleError)
    $(window).off('flash.hide', @handleHide)

  handleNotice: (event, msg) ->
    @setState msg: msg, className: 'notice'

  handleError: (event, msg) ->
    @setState msg: msg, className: 'error'

  handleHide: (event) ->
    event.preventDefault()
    @setState msg: "", className: 'hidden'

  render: ->
    className = "flash #{this.state.className}"
    `<aside className={className}>
      <a className="flash__close" onClick={this.handleHide} href="#hideflash">
        <i className="fa fa-times"/>
      </a>
      {this.state.msg}
    </aside>`
