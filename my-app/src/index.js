import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './join';
import Game from './game';
import registerServiceWorker from './registerServiceWorker';

fetch('/game', {
  method: 'get'
}).then(data => data.json()).then(object => {
  const game = object.game;
  if(game == null){
    ReactDOM.render(<App/>, document.getElementById('root'));
    registerServiceWorker();
  } else {
    ReactDOM.render(<Game/>, document.getElementById('root'));
    registerServiceWorker();
  }
});
