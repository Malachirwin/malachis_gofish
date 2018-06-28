import React from 'react';
import '../App.css';

class EndGame extends React.Component {
  constructor(props) {
    super(props)
    this.state = {result: null}
  }
  componentDidMount() {
    fetch("/winner", {
      method: "get"
    }).then(data => data.json()).then(object => {
      this.setState({
        result: object.result
      })
    })
  }
  handleSubmit() {
    this.props.updateState("join")
  }

  render() {
    if(this.state.result !== null) {
      return (
        <div className="endGame">
          <header className="App-header">
            <img src="cards/ha.png" className="App-logo" alt="logo" />
            <h1 className="App-title">Go fish</h1>
          </header>
          <h1>{this.state.result}</h1>
          <div>
            <form onSubmit={() => {this.props.updateState("join")}}>
              <button>ReJoin</button>
            </form>
          </div>
        </div>
      );
    }else{
      return (
        <div>the game is not done</div>
      )
    }
  }
}

export default EndGame;
