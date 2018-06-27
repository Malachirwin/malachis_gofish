import Join from "./join";
import React from 'react';
import Game from './game';

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {value: "join"}
  }
  updateState() {
    this.setState({value: "game"})
  }
  render() {
    if(this.state.value === "game") {
      return (
        <div className="App">
          <Game/>
        </div>
      );
    }else{
      return (
        <div className="App">
          <Join updateState={this.updateState.bind(this)}/>
        </div>
      );
    }
  }
}

export default App;
