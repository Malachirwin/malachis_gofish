import React from 'react';
import '../App.css';

class HumanPlayer extends React.Component {
  render() {
    if(this.props.player.matches !== []) {
      if(this.props.turn === true) {
        return (
          <div>
            <h1>It is your turn</h1>
            <h1>{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} alt=""/>
              )
            }
          </div>
        );
      }else{
        return (
          <div>
            <h1>{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} alt=""/>
              )
            }
          </div>
        );
      }
    }else{
      if(this.props.turn === true) {
        return (
          <div>
          <h1>It is your turn</h1>
            <h1>{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} alt=""/>
              )
            }
          </div>
        )
      }else{
        return (
          <div>
            <h1>{this.props.name}</h1>
            {this.props.hand.map((card, index) =>
              <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} alt=""/>
              )
            }
          </div>
        )
      }
    }
  }
}

export default HumanPlayer;
