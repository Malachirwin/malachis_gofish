import React from 'react';
import '../App.css';

class Center extends React.Component {
  render() {
    if(this.props.cardsLeftInDeck > 0) {
      return (
        <div className="center-cards">
          <h2>-Center Pile-</h2>
          <img src="cards/backs_custom.jpg" alt="backs custom"/>
          <img src="cards/backs_custom.jpg" alt="backs custom"/>
          <img src="cards/backs_custom.jpg" alt="backs custom"/>
          <img src="cards/backs_custom.jpg" alt="backs custom"/>
          <img src="cards/backs_custom.jpg" alt="backs custom"/>
          <img src="cards/backs_custom.jpg" alt="backs custom"/>
        </div>
      );
    }else{
      return (
        <div className="playing-space"></div>
      )
    }
  }
}

export default Center;
