import React from 'react';
import './App.css';

class Game extends React.Component {
  render() {
    return (
      <div className="Game">
        <header className="Game-header">
          <img src="cards/ha.png" className="Game-logo" alt="logo" />
          <h1 className="App-title">Go fish</h1>
        </header>
        <h1>Hello World</h1>
      </div>
    );
  }
}

export default Game;
