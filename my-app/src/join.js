import React from 'react';
import './App.css';
import ReactDOM from 'react-dom'

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    fetch('/', {
      method: 'POST',
      body: JSON.stringify({
        name: this.state.value
      })
    })
    event.preventDefault();
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src="cards/ha.png" className="App-logo" alt="logo" />
          <h1 className="App-title">Go fish</h1>
        </header>
        <form onSubmit={this.handleSubmit}>
          <p> Please enter your name </p>
          <br />
          <input name="name" type="text" required="" value={this.state.value} onChange={this.handleChange}/>
          <input type='submit' value='Submit'/>
        </form>
      </div>
    );
  }
}

export default App;
