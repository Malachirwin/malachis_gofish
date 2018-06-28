import React from 'react';
import '../App.css';

class Log extends React.Component {
  render() {
    return (
      <div>
        {this.props.logs.map((book, index) =>
          <h4 className="book" key={`books${index}`}>{book}</h4>
        )}
      </div>
    )
  }
}

class GameLog extends React.Component {
  constructor(props) {
    super(props)
    this.state = {}
  }
  whenClick() {
    if(this.state.showResults === false) {
      this.setState({showResults: true})
    }else{
      this.setState({showResults: false})
    }
  }
  render() {
    return (
      <div className="log">
        <div>
            <h1 className="less-top-margin" onClick={this.whenClick.bind(this)}>-Game Log-</h1>
            { this.state.showResults ? <Log logs={this.props.log.slice(0).reverse().slice(0, 15)}/> : null
            }
        </div>
      </div>
    );
  }
}

export default GameLog;
