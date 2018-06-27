import React from 'react';
import '../App.css';

class HumanPlayer extends React.Component {
  render() {
    return (
      <div>
        <h1>{this.props.name}</h1>
        {this.props.hand.map((card, index) =>
          <img key={'mykey' + index} className="hand" src={`cards/${card.to_img_path}.png`} alt="" onclick="myFunction()"/>
          )
        }
        <p id="demo">hello</p>
        <p id="Malachi">jim</p>
        <script>
          function myFunction() {
            document.getElementById("demo") = 
          }
          </script>
      </div>
    );
  }
}

export default HumanPlayer;
