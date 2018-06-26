import Join from "./join";
import React from 'react';
import Game from './game';

class App extends React.Component {
  updateStatus() {
    this.setState = Game
  }
  render() {
    return (
      <div className="App">
        <Join updateStatus={this.updateStatus.bind(this)}/>
      </div>
    );
  }

}

export default App;
