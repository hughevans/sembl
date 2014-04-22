#= require views/utils/utils 
#= require views/utils/transloadit_handlers 

###* @jsx React.DOM ###
{TransloaditBoredInstance, TransloaditSignature} = @Sembl.Handlers

@Sembl.Components.TransloaditUploadComponent = React.createClass
  getInitialState: ->
    state: 'initialising'
    progress: 0

  componentWillMount: ->
    new TransloaditBoredInstance(@foundBoredInstance)
    new TransloaditSignature('thingsStoreOriginal', @signatureLoaded)

  componentDidMount: -> 
    @submitOnFileSelected()

  componentDidUpdate: ->
    @submitOnFileSelected()

  foundBoredInstance: (apiHost) ->
    @transloaditInstance = apiHost
    @checkInitComplete()

  signatureLoaded: (template) ->
    @uploadTemplate = template
    @checkInitComplete()

  checkInitComplete: -> 
    if @transloaditInstance and @uploadTemplate
      @assemblyId  = window.Sembl.Utils.genUUID()
      @assemblyUrl = "#{window.Sembl.Utils.PROTOCOL}://#{@transloaditInstance}/assemblies/#{@assemblyId}"
      @postUrl     = "#{@assemblyUrl}?redirect=false"
      @setState state: 'ready'

  submitOnFileSelected: -> 
    $el = $(@getDOMNode())
    $el.find('input:file').on('change', => 
      $el.find('form').submit()
      @handleSubmit()
    )

  handleSubmit: ->
    @setState state: 'uploading'
    @uploadPoll()

  uploadPoll: ->
    setTimeout @queryAssembly, 1000

  updateProgress: (data) -> 
    console.log data
    pctProgress = 0
    pctProgress = (data.bytes_received/data.bytes_expected) * 100 if data.bytes_expected
    @state.progress = pctProgress
    @state.state = 'processing' if pctProgress == 100
    @setState @state

  queryAssembly: ->
    $.ajax
      context: this
      dataType: 'json'
      url: @assemblyUrl
      success: (data) ->
        if data.ok is 'ASSEMBLY_COMPLETED'
          @props.finishedUpload data.results
        else
          @updateProgress(data)
          @uploadPoll()

  render: ->
    hidden = display: 'none'
    console.log 'rendering upload component', @state
    componentForState = switch @state.state
      when 'initialising'
        `<span>Loading…</span>`

      when 'uploading'
        progressWidth = width: @state.progress + "%"
        `<div className="upload__progress-bar">
          <div className="upload__progress-bar__pct" style={progressWidth}/>
        </div>`

      when 'processing'
        `<span>Processing…</span>`

      when 'ready'
        `<form
          encType="multipart/form-data"
          onSubmit={this.handleSubmit}
          action={this.postUrl}
          target="transloadit"
          method="POST"
        >
          <input name="params" type="hidden" value={JSON.stringify(this.uploadTemplate.params)} />
          <input name="signature" type="hidden" value={this.uploadTemplate.signature} />
          <input name="thing" type="file" />
        </form>` 

    `<div className="upload">
      <iframe name="transloadit" style={hidden} />
      {componentForState}
    </div>`