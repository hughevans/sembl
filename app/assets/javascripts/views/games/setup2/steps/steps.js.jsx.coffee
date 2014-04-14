###* @jsx React.DOM ###

###
  Component for stepping through other components with next, back and done buttons.
  if a step has a 'validate' properties set to true then the next/done buttons are disabled 
  until a setup.steps.change event occurs with {valid: true} in the data.

  Each step can aggregate any changes by sending a setup.steps.change event with {properties: ...}
  These properties will passed back into the step (and other steps), using this.props. Thus state is
  managed by the Steps component not the individual steps.

  When all steps a done, a setup.steps.done event is triggered and passed any data collected.
###
@Sembl.Games.Setup.Steps = React.createClass
  componentWillMount: ->
    $(window).on('setup.steps.change', @handleChange)
    $(window).on('setup.steps.valid', @handleValid)

  componentWillUnmount: ->
    $(window).off('setup.steps.change')
    $(window).off('setup.steps.valid')

  componentDidMount: ->
    @validateStep()

  componentDidUpdate: ->
    @validateStep()

  getInitialState: ->
    step: 0
    collectedFields: @props.collectedFields || {}
    valid: false

  validateStep: ->
    valid = if @refs.currentStep.isValid? then @refs.currentStep.isValid() else true
    if valid != @state.valid
      @setState({valid:valid})

  handleNext: ->
    @setState
      step: Math.min(@state.step + 1, @props.steps.length - 1)

  handlePrevious: ->
    @setState
      step: Math.max(@state.step - 1, 0)

  handleDone: ->
    $(window).trigger('setup.steps.done', @state.collectedFields)

  handleValid: (event, data) ->
    @setState
      valid: data.valid

  handleChange: (event, data) ->
    _.extend(@state.collectedFields, data)
    @setState(@state)

  render: ->
    steps = @props.steps
    
    if @state.step < steps.length
      isValid = @state.valid
    
      childProperties = _.extend({ref: 'currentStep'}, @state.collectedFields)
      console.log 'childProperties', childProperties
      step = steps[@state.step]
      if React.isValidClass(step)
        step = step(childProperties)
      else if React.isValidComponent(step)
        step = React.addons.cloneWithProps(step, childProperties)
      else 
        throw "invalid step, must be react class or component"

    isLast = @state.step == steps.length - 1

    actionClassName = (action, disabled) -> 
      className = "setup__steps__actions__#{action}"
      className += " button--disabled" if disabled
      className

    previous = `<button className={actionClassName('previous')} onClick={this.handlePrevious}>Back</button>`
    next = `<button className={actionClassName('next', !isValid)} onClick={this.handleNext}>Next</button>`
    done = `<button className={actionClassName('done', !isValid)} onClick={this.handleDone}>Done</button>`

    `<div className="setup__steps">
      {step}
      <div className="setup__steps__actions">
        {this.state.step > 0 ? previous : null}
        {!isLast ? next :  done}
      </div>
    </div>`
     