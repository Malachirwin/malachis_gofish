import React from 'react';
import '../App.css';
import RobotPlayer from './bot'
import HumanPlayer from './humanPlayer'
import Center from './center'
import GameLog from './gameLog'

class Game extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      game: null,
      targetCard: "",
      targetPlayer: ""
    }
  }
  componentDidMount() {
    fetch("/game", {
      method: "get"
    }).then(data => data.json()).then(object => {
      this.setState({
        game: object.game,
        log: object.log,
        cardsLeftInDeck: object.cards_left_in_deck
      })
    })
  }
  targetCard(card) {
    this.setState({targetCard: card})
  }

  targetPlayer(player) {
    this.setState({targetPlayer: player})
  }

  render() {
    if(this.state.game !== null) {
      const bots = this.state.game.players.slice(0)
      const hand = this.state.game.players[0].hand
      const player = this.state.game.players[0]
      const log = this.state.log
      bots.splice(0, 1)
      let turn;
      if(this.state.game.name_of_playing_player === player.name) {
        turn = true
      }else{
        turn = false
      }
      return (
        <div className="Game">
          <header className="App-header">
            <img src="cards/ha.png" className="App-logo" alt="logo" />
            <h1 className="App-title">Go fish</h1>
          </header>
          <div className="holder">
            {bots.map((bot, index) =>
              <RobotPlayer className="bot" key={`bot${index}`} matches={bot.matches} targetPlayerValue={this.state.targetPlayer} targetPlayer={this.targetPlayer.bind(this)} name={bot.name} turn={turn} bot={bot} index={index}/>
              )
            }
          </div>
          <Center className="playing-space" cardsLeftInDeck={this.state.cardsLeftInDeck}/>
          <HumanPlayer className="player" updateState={this.props.updateState.bind(this)} matches={player.matches} targetPlayerValue={this.state.targetPlayer} targetCardValue={this.state.targetCard} targetCard={this.targetCard.bind(this)} name={player.name} turn={turn} player={player} hand={hand}/>
          <GameLog className="log" log={log}/>
        </div>
      );
    }else{
      return (
        <div className="loader-container"><div className="loader"></div></div>
      )
    }
  }
}

export default Game;
