import React from 'react';
import '../App.css';

class HumanPlayer extends React.Component {
  getRank(card) {
    return card.rank_value
  }

  handleSubmitSkip(event) {
    event.preventDefault();
    fetch('/request_card', {
      method: 'POST',
      body: JSON.stringify({
        desired_rank: false,
        player_who_was_asked: false
      })
    }).then(data => data.json()).then(object => {
      console.log(object)
      if(object.result !== "no winner yet"){
        this.props.updateState("endGame")
      }else{
        this.props.updateState("game is ready")
        this.props.updateGameState(object.game_state.game, object.game_state.log, object.game_state.cards_left_in_deck)
      }
    })
  }

  handleSubmit(event) {
    event.preventDefault();
    fetch('/request_card', {
      method: 'POST',
      body: JSON.stringify({
        desired_rank: this.props.targetCardValue,
        player_who_was_asked: this.props.targetPlayerValue
      })
    }).then(data => data.json()).then(object => {
      console.log(object)
      if(object.result !== "no winner yet"){
        this.props.updateState("endGame")
      }else{
        this.props.updateState("game is ready")
        this.props.updateGameState(object.game_state.game, object.game_state.log, object.game_state.cards_left_in_deck)
      }
    })
  }

  getCorrectRank(card, index) {
    if(card.rank_value === this.props.targetCardValue) {
      return (
        <img key={'mykey' + index} className="hand highlight" src={`cards/${card.to_img_path}.png`} onClick={() => {this.props.targetCard(this.getRank(card))}} alt=""/>
      )
    }else{
      return (
        <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} onClick={() => {this.props.targetCard(this.getRank(card))}} alt=""/>
      )
    }
  }
  render() {
    if(this.props.hand.length === 0) {
      return (
        <div className="player">
          <h1>There are no cards left in the deck and in your hand click the button to skip your turn</h1>
          <form onSubmit={this.handleSubmitSkip.bind(this)}>
            <button>Skip</button>
          </form>
          {this.props.matches.map((match, index) =>
            <div key={'mykey' + index} className="matches">
              <span className="inbetween-match"/>
              {match.map((card, index) =>
                <img key={'mykey' + index} className="match" src={`cards/${card.to_img_path}.png`} alt=""/>
                )
              }
            </div>
            )
          }
        </div>
      )
    }else if(this.props.targetCardValue !== '' && this.props.targetPlayerValue !== '') {
      if(this.props.turn === true) {
        return (
          <div className="player">
            <h1>It is your turn</h1>
            <p>Then click the button to submit</p>
            <form onSubmit={this.handleSubmit.bind(this)}>
              <button className="submit">Request Card</button>
            </form>
            <h1>{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              this.getCorrectRank(card, index)
              )
            }
            <div>
              {this.props.matches.map((match, index) =>
                <div  key={'my-key' + index} className="matches">
                  <span className="inbetween-match"/>
                  {match.map((card, index) =>
                    <img key={'mykey' + index} className="match" src={`cards/${card.to_img_path}.png`} alt=""/>
                    )
                  }
                </div>
                )
              }
            </div>
          </div>
        );
      }else{
        return (
          <div className="player">
            <h1>{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} onClick={() => {this.props.targetCard(this.getRank(card))}} alt=""/>
              )
            }
            <div>
              {this.props.matches.map((match, index) =>
                <div key={'mykey' + index} className="matches">
                  <span className="inbetween-match"/>
                  {match.map((card, index) =>
                    <img key={'mykey' + index} className="match" src={`cards/${card.to_img_path}.png`} alt=""/>
                    )
                  }
                </div>
                )
              }
            </div>
          </div>
        );
      }
    }else{
      if(this.props.turn === true) {
        return (
          <div className="player">
            <h1>It is your turn</h1>
            <p className="closser-to-gether">To ask a player for a card</p>
            <p className="closser-to-gether"> you click a player</p>
            <p className="closser-to-gether">then click a card</p>
            <h1 className="further-from">{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              this.getCorrectRank(card, index)
              )
            }
            <div>
              {this.props.matches.map((match, index) =>
                <div key={'my-key' + index} className="matches">
                  <span className="inbetween-match"/>
                  {match.map((card, index) =>
                    <img key={'mykey' + index} className="match" src={`cards/${card.to_img_path}.png`} alt=""/>
                    )
                  }
                </div>
                )
              }
            </div>
          </div>
        );
      }else{
        return (
          <div className="player">
            <h1>{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} onClick={() => {this.props.targetCard(this.getRank(card))}} alt=""/>
              )
            }
            <div>
              {this.props.matches.map((match, index) =>
                <div className="matches">
                  <span className="inbetween-match"/>
                  {match.map((card, index) =>
                    <img key={'mykey' + index} className="match" src={`cards/${card.to_img_path}.png`} alt=""/>
                    )
                  }
                </div>
                )
              }
            </div>
          </div>
        );
      }
    }
  }
}

export default HumanPlayer;
