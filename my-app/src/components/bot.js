import React from 'react';
import '../App.css';

class RobotPlayer extends React.Component {
  render() {
    return (
      <div className="robotPlayer">
        <div>
          <h1 key={'mykey' + this.props.index}>{this.props.name}</h1>
          {this.props.bot.hand.map((card, index) =>
            <img key={'mykey' + index} className="hand" src="cards/backs_custom.jpg" alt=""/>
            )
          }
        </div>
      </div>
    );
  }
}

export default RobotPlayer;
