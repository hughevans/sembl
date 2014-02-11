//= require views/search_list
//= require views/search_form
/** @jsx React.DOM */
window.Sembl.SearchEdit = React.createClass({
  getInitialState: function() {
    return {
      things: this.props.initialThings,
      query: this.props.initialQuery
    };
  },

  handleSearch: function() {
    var searchEdit = this;
    var things = $.getJSON("/search.json", this.state.query, function(data){
      searchEdit.setState({things: data});
    });
  },

  handleQueryChange: function(query_parameters) {
    this.setState({query: query_parameters});
  },

  render: function() {
    var SearchList = Sembl.SearchList
    var SearchForm = Sembl.SearchForm
    return (
      <div className="searchEdit">
        <SearchForm query={this.state.query} handleQueryChange={this.handleQueryChange} handleSearch={this.handleSearch} />
        <SearchList things={this.state.things} />
      </div>
    );
  }
});
