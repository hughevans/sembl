#= require 'jquery'

###* @jsx React.DOM ###

Sembl.Games.MoreInfoView = React.createClass
  toggleDescriptionPopup: ->
    el = @isMounted() && @getDOMNode()
    description = $(el).find('.header__description').toggleClass('hidden')

  render: ->
    `<div className="header__more-info">
      <i className="fa fa-info-circle" onClick={this.toggleDescriptionPopup}></i>
      <div className="header__description hidden">
        {this.props.game.get('description')}
      </div>
    </div>`

{MoreInfoView} = Sembl.Games

Sembl.Games.HeaderView = React.createClass

  componentDidMount: ->
    @offsetRoundTab();

  offsetRoundTab: ->
    headerTabWidth = $('.header__round').outerWidth()
    $('.header__round').css 'margin-left', ((headerTabWidth / 2) * -1) + 'px'

  handleJoin: ->
    @props.handleJoin()

  render: ->
    game = @props.game

    headerTitle = `<h1 className="header__title">
        {game.get('title')}
      </h1>`

    join = `<a className='header__join' onClick={this.handleJoin}>
      Join Game
    </a>` if game.canJoin()


    moreInfo = `<MoreInfoView game={this.props.game}/>` if  !!game.get('description')

    editUrl = "/games/" + game.get('id') + "/edit"
    edit = `<li className="header__link">
        <i className="fa fa-pencil header__link-icon"></i>
        <a href={editUrl} className="header__link-anchor">Edit</a>
      </li>` if game.get('is_hosting')

    roundResults = `<li className="header__link">
        <i className="fa fa-trophy header__link-icon"></i>
        <a href="#" className="header__link-anchor">
          <span className="header__link-truncate">Round&nbsp;</span>
          Results
        </a>
      </li>`

    help = `<li className="header__link">
        <i className="fa fa-question-circle header__link-icon"></i> 
        <a href="#" className="header__link-anchor">Help</a>
      </li>`

    return `<div className="header__components">
      {headerTitle}
      {moreInfo}
      <div className="header__centre-title">
        {this.props.children}
      </div>
      <ul className="header__links">
        {join}
        {edit}
        {roundResults}
      </ul>
    </div>`