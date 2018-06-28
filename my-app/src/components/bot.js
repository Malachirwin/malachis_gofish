import React from 'react';
import '../App.css';

class RobotPlayer extends React.Component {
  render() {
    if(this.props.bot.matches !== []) {
      if(this.props.turn === true) {
        if(this.props.targetPlayerValue === this.props.bot.name){
          return (
            <div className="robotPlayer" onClick={() => {this.props.targetPlayer(this.props.bot.name)}}>
              <div>
                <h1 key={'mykey' + this.props.index} className="highlight">{this.props.name}</h1>
                {this.props.bot.hand.map((card, index) =>
                  <img key={'mykey' + index} className="hand" src="cards/backs_custom.jpg" alt=""/>
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
            </div>
          );
        }else{
          return (
            <div className="robotPlayer" onClick={() => {this.props.targetPlayer(this.props.bot.name)}}>
              <div>
                <h1 key={'mykey' + this.props.index}>{this.props.name}</h1>
                {this.props.bot.hand.map((card, index) =>
                  <img key={'mykey' + index} className="hand" src="cards/backs_custom.jpg" alt=""/>
                  )
                }
                <div>
                  {this.props.matches.map((match, index) =>
                    <div key={'my-key' + index}className="matches">
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
            </div>
          );
        }
      }else{
        return (
          <div className="robotPlayer">
            <div>
              <h1 key={'mykey' + this.props.index}>{this.props.name}</h1>
              {this.props.bot.hand.map((card, index) =>
                <img key={'mykey' + index} className="hand" src="cards/backs_custom.jpg" alt=""/>
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
          </div>
        );
      }
    }else{
      return (
        <div className="robotPlayer">
          <div>
            <h1 key={'mykey' + this.props.index}>{this.props.name}</h1>
            {this.props.bot.hand.map((card, index) =>
              <img key={'mykey' + index} className="hand" src="cards/backs_custom.jpg" alt=""/>
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
        </div>
      )
    }
  }
}

export default RobotPlayer;
