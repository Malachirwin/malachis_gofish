import React from 'react';
import '../App.css';
import ReactDOM from 'react-dom';
class GameLog extends React.Component {
  constructor(props) {
    super(props)
    this.state = {showResults: false}
  }
  whenClick() {
    this.setState({showResults: true})
  }
  render() {
    return (
      <div className="log">
        <div>
            <input type="submit" value="-Game Log-" onClick={this.whenClick.bind(this)} />
            { this.state.showResults ? <div>
                {this.props.log.slice(0).reverse().slice(0, 15).map((book, index) =>
                  <h4 className="book" key={`books${index}`}>{book}</h4>
                )}
              </div> : null
            }
        </div>
      </div>
    );
  }
}

export default GameLog;
