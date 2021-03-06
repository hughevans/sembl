#= require views/games/setup/form

###* @jsx React.DOM ###

{Form} = Sembl.Games.Setup
@Sembl.Games.Setup.New = React.createClass
  render: ->
    `<Form className="setup"
        firstSteps={['board','title']}
        game={this.props.game}
        user={this.props.user} />`

@Sembl.views.setupNew = ($el, el) ->
  Sembl.game = new Sembl.Game($el.data().game);

  @layout = React.renderComponent(
    Sembl.Layouts.Default()
    document.getElementsByTagName('body')[0]
  )
  @layout.setProps
    body: Sembl.Games.Setup.New(game: Sembl.game, user: Sembl.user),
    header: Sembl.Games.HeaderView(model: Sembl.game, title: "New Game")

