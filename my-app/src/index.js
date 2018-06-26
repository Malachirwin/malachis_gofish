import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './join';
import Game from './game';
import registerServiceWorker from './registerServiceWorker';

fetch('http://localhost:3000/game', {
  method: 'get'
}).then((data) => {
  console.log(data.json())
  if(data){
    ReactDOM.render(<data/>, document.getElementById('root'));
  }else{
    ReactDOM.render(<App/>, document.getElementById('root'));
  }
});
registerServiceWorker();
