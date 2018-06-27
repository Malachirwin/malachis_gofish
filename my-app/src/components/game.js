import React from 'react';
import '../App.css';
import RobotPlayer from './bot'
import HumanPlayer from './humanPlayer'
import Center from './center'

class Game extends React.Component {
  constructor(props) {
    super(props)
    this.state = {game: null}
  }
  componentDidMount() {
    fetch("/game", {
      method: "get"
    }).then(data => data.json()).then(object => {
      this.setState({game: object.game})
    })
  }

  render() {
    if(this.state.game !== null) {
      const bots = this.state.game.players.slice(0)
      const hand = this.state.game.players[0].hand
      const player = this.state.game.players[this.state.game.players.length - 1]
      bots.splice((bots.length - 1), 1)
      return (
        <div className="Game">
          <header className="App-header">
            <img src="cards/ha.png" className="App-logo" alt="logo" />
            <h1 className="App-title">Go fish</h1>
          </header>
          <div className="holder">
            {bots.map((bot, index) =>
              <RobotPlayer className="bot" key={`bot${index}`} name={bot.name} bot={bot} index={index}/>
              )
            }
          </div>
          <Center className="playing-space"/>
          <HumanPlayer className="player" name={player.name} hand={hand}/>
        </div>
      );
    }else{
      return (
        <div></div>
      )
    }
  }
}

export default Game;
