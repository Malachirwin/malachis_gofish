import React from 'react';
import '../App.css';

class Join extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};
    this.numberState = ''
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleNumberChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    event.preventDefault();
    fetch('/join', {
      method: 'POST',
      body: JSON.stringify({
        name: this.state.value,
        number_of_players: this.menu.value
      })
    }).then(data => this.props.updateState("game"))
  }

  render() {
    return (
      <div className="App-join">
        <header className="App-header">
          <img src="cards/backs_custom.jpg" className="App-logo" alt="logo" />
          <h1 className="App-title">Go fish</h1>
        </header>
        <form onSubmit={this.handleSubmit.bind(this)}>
          <p> Please enter your name and select the number of players you want to play with</p>
          <br />
          <input name="name" type="text" required="" value={this.state.value} onChange={this.handleChange.bind(this)}/>
          <select ref = {(input)=> this.menu = input}>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
            <option value="6">6</option>
          </select>
          <br />
          <button type='submit'>Submit</button>
        </form>
      </div>
    );
  }
}

export default Join;
