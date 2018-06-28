import Join from "./join";
import React from 'react';
import Game from './game';
import EndGame from './endGame';

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {value: "join"}
  }
  updateState(str) {
    this.setState({value: str})
  }
  componentDidMount() {
    fetch("/app", {
      method: "get"
    }).then(data => data.json()).then(game => {
      fetch("/winner", {
        method: "get"
      }).then(data => data.json()).then(object => {
        if(object.result === "no winner yet") {
          if(game["game"] === true) {
            this.setState({value: "game"})
          }else{
            this.setState({value: "join"})
          }
        }else{
          this.setState({value: "endGame"})
        }
      })
    })
  }
  render() {
    if(this.state.value === "game") {
      return (
        <div className="App">
          <Game updateState={this.updateState.bind(this)}/>
        </div>
      )
    }else if(this.state.value === "join"){
      return (
        <div className="App">
          <Join updateState={this.updateState.bind(this)}/>
        </div>
      )
    }else{
      return (
        <div className="App">
          <EndGame updateState={this.updateState.bind(this)}/>
        </div>
      )
    }
  }
}

export default App;
