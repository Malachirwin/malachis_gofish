import React from 'react';
import './App.css';

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
    event.preventDefault();
    fetch('/', {
      method: 'POST',
      body: JSON.stringify({
        name: this.state.value
      })
    }).then(data => data.json()).then(object => {
      console.log(object)
      // redirect_to `/games/${object.game_id}`
      // ReactDOM.render(<Game/>, document.getElementById('root'));
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
          <input type='submit' value='Submit'/>
        </form>
      </div>
    );
  }
}

export default App;
