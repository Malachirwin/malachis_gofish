import React from 'react';
import './App.css';

class Join extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount(){
    fetch('/game', {
      method: 'get'
    }).then(data => data.json()).then(object => {
      const game = object.game;
      console.log(object)
    });
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    event.preventDefault();
    fetch('/join', {
      method: 'POST',
      body: JSON.stringify({
        name: this.state.value
      })
    }).then(data => data.json()).then(object => {
      console.log(object)
      this.updateStatus
      this.componentDidMount()
    });
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
          <button type='submit'>Submit</button>
        </form>
      </div>
    );
  }
}

export default Join;
